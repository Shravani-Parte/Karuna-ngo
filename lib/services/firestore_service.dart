import 'package:cloud_firestore/cloud_firestore.dart';
import '../models.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Collection references
  CollectionReference get users => _db.collection('users');
  CollectionReference get ngos => _db.collection('ngos');
  CollectionReference get pledges => _db.collection('pledges');
  CollectionReference get donations => _db.collection('donations');

  // Add user to Firestore
  Future<void> addUser(String uid, Map<String, dynamic> userData) async {
    await users.doc(uid).set(userData);
  }

  // Get user data
  Future<DocumentSnapshot> getUser(String uid) async {
    return await users.doc(uid).get();
  }

  // Update user data
  Future<void> updateUser(String uid, Map<String, dynamic> userData) async {
    await users.doc(uid).update(userData);
  }

  // Add NGO to Firestore
  Future<DocumentReference> addNgo(Map<String, dynamic> ngoData) async {
    return await ngos.add(ngoData);
  }

  // Get all NGOs
  Stream<QuerySnapshot> getNgos() {
    return ngos.snapshots();
  }

  // Get NGO by ID
  Future<DocumentSnapshot> getNgo(String ngoId) async {
    return await ngos.doc(ngoId).get();
  }

  // Update NGO
  Future<void> updateNgo(String ngoId, Map<String, dynamic> ngoData) async {
    await ngos.doc(ngoId).update(ngoData);
  }

  // Add pledge
  Future<DocumentReference> addPledge(Map<String, dynamic> pledgeData) async {
    return await pledges.add(pledgeData);
  }

  // Get pledges for a user (donor or NGO)
  Stream<QuerySnapshot> getPledgesForUser(String userId, {String? userType}) {
    if (userType == 'ngo') {
      return pledges.where('ngoId', isEqualTo: userId).snapshots();
    } else {
      return pledges.where('donorId', isEqualTo: userId).snapshots();
    }
  }

  // Get pending pledges for NGO
  Stream<QuerySnapshot> getPendingPledgesForNgo(String ngoId) {
    return pledges
        .where('ngoId', isEqualTo: ngoId)
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }

  // Get ongoing pledges for NGO
  Stream<QuerySnapshot> getOngoingPledgesForNgo(String ngoId) {
    return pledges
        .where('ngoId', isEqualTo: ngoId)
        .where('status', whereIn: ['ongoing', 'accepted'])
        .snapshots();
  }

  // Update pledge status
  Future<void> updatePledgeStatus(String pledgeId, String status) async {
    await pledges.doc(pledgeId).update({'status': status});
  }

  // Search NGOs with filters
  Stream<QuerySnapshot> searchNgos({
    String? category,
    String? area,
    String? resourceType,
  }) {
    Query query = ngos;

    if (category != null && category != 'All') {
      query = query.where('category', isEqualTo: category);
    }

    if (area != null && area != 'All') {
      query = query.where('area', isEqualTo: area);
    }

    // For resourceType, we can filter based on 'need' field containing keywords
    if (resourceType != null && resourceType != 'All') {
      String keyword;
      switch (resourceType) {
        case 'Monetary':
          keyword = 'fund';
          break;
        case 'Time (Volunteer)':
          keyword = 'volunteer';
          break;
        default:
          keyword = '';
      }
      if (keyword.isNotEmpty) {
        query = query.where('need', arrayContains: keyword);
      }
    }

    return query.snapshots();
  }

  // Add donation
  Future<DocumentReference> addDonation(Map<String, dynamic> donationData) async {
    return await donations.add(donationData);
  }

  // Get donations for a user (donor or NGO)
  Stream<QuerySnapshot> getDonationsForUser(String userId, {String? userType}) {
    if (userType == 'ngo') {
      return donations.where('ngoId', isEqualTo: userId).snapshots();
    } else {
      return donations.where('donorId', isEqualTo: userId).snapshots();
    }
  }

  // Update donation status
  Future<void> updateDonationStatus(String donationId, String status) async {
    await donations.doc(donationId).update({'status': status});
  }
}
