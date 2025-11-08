// Data Models compatible with Firestore
import 'package:cloud_firestore/cloud_firestore.dart';
class Ngo {
  final String id;
  final String name;
  final String category;
  final String area;
  final String need;
  final double rating;
  final String imageUrl;
  final String description;
  final String? contact;
  final String? website;
  final String? ngoId;
  final String? registrationId;

  Ngo({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.need,
    required this.rating,
    required this.imageUrl,
    this.description = 'A dedicated non-profit organization focused on making a difference in the local community.',
    this.contact,
    this.website,
    this.ngoId,
    this.registrationId,
  });

  // Factory constructor to create Ngo from Firestore document
  factory Ngo.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      // Handle case where document exists but has no data - provide defaults
      return Ngo(
        id: doc.id,
        name: 'NGO Name Not Set',
        category: 'General',
        area: 'Location Not Set',
        need: 'Needs Not Specified',
        rating: 0.0,
        imageUrl: '',
        description: 'A dedicated non-profit organization focused on making a difference in the local community.',
        contact: null,
        website: null,
        ngoId: null,
        registrationId: null,
      );
    }
    return Ngo(
      id: doc.id,
      name: data['name'] ?? 'NGO Name Not Set',
      category: data['category'] ?? 'General',
      area: data['area'] ?? 'Location Not Set',
      need: data['need'] ?? 'Needs Not Specified',
      rating: (data['rating'] ?? 0.0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? 'A dedicated non-profit organization focused on making a difference in the local community.',
      contact: data['contact'],
      website: data['website'],
      ngoId: data['ngoId'],
      registrationId: data['registrationId'],
    );
  }

  // Convert Ngo to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'area': area,
      'need': need,
      'rating': rating,
      'imageUrl': imageUrl,
      'description': description,
      'contact': contact,
      'website': website,
      'ngoId': ngoId,
      'registrationId': registrationId,
    };
  }
}

class Donation {
  final String id;
  final String ngoId;
  final String donorId;
  final String item;
  final String date;
  final String status;
  final String ngoName;

  Donation({
    required this.id,
    required this.ngoId,
    required this.donorId,
    required this.item,
    required this.date,
    required this.status,
    required this.ngoName,
  });

  // Factory constructor to create Donation from Firestore document
  factory Donation.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Donation document data is null');
    }
    return Donation(
      id: doc.id,
      ngoId: data['ngoId'] ?? '',
      donorId: data['donorId'] ?? '',
      item: data['item'] ?? '',
      date: data['date'] ?? '',
      status: data['status'] ?? 'pending',
      ngoName: data['ngoName'] ?? '',
    );
  }

  // Convert Donation to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'ngoId': ngoId,
      'donorId': donorId,
      'item': item,
      'date': date,
      'status': status,
      'ngoName': ngoName,
    };
  }
}

class Pledge {
  final String id;
  final String title;
  final String ngoId;
  final String ngoName;
  final String location;
  final String status;
  final String? donorId;
  final String? donorName;

  Pledge({
    required this.id,
    required this.title,
    required this.ngoId,
    required this.ngoName,
    required this.location,
    this.status = 'pending',
    this.donorId,
    this.donorName,
  });

  // Factory constructor to create Pledge from Firestore document
  factory Pledge.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Pledge document data is null');
    }
    return Pledge(
      id: doc.id,
      title: data['title'] ?? '',
      ngoId: data['ngoId'] ?? '',
      ngoName: data['ngoName'] ?? '',
      location: data['location'] ?? '',
      status: data['status'] ?? 'pending',
      donorId: data['donorId'],
      donorName: data['donorName'],
    );
  }

  // Convert Pledge to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'ngoId': ngoId,
      'ngoName': ngoName,
      'location': location,
      'status': status,
      'donorId': donorId,
      'donorName': donorName,
    };
  }
}

class UserModel {
  final String uid;
  final String email;
  final String userType; // 'donor' or 'ngo'
  final String? name;
  final String? contact;
  final String? bio;
  final String? ngoId; // For donors linked to NGO, or for NGO users

  UserModel({
    required this.uid,
    required this.email,
    required this.userType,
    this.name,
    this.contact,
    this.bio,
    this.ngoId,
  });

  // Factory constructor to create UserModel from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('User document data is null');
    }
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      userType: data['userType'] ?? 'donor',
      name: data['name'],
      contact: data['contact'],
      bio: data['bio'],
      ngoId: data['ngoId'],
    );
  }

  // Convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'userType': userType,
      'name': name,
      'contact': contact,
      'bio': bio,
      'ngoId': ngoId,
    };
  }
}

// Mock Data Source (keeping for backward compatibility, but will be replaced with Firestore data)
final List<Ngo> mockNgos = [
  Ngo(id: '1', name: 'Clean Rivers Initiative', category: 'Environment', area: 'Mumbai', need: 'Water filters, Volunteers', rating: 4.8, imageUrl: '', description: 'Working to clean up local rivers and educate communities on waste management and pollution control.'),
  Ngo(id: '2', name: 'Future Leaders Academy', category: 'Education', area: 'Delhi', need: 'Laptops, Notebooks', rating: 4.5, imageUrl: '', description: 'Providing quality education and resources to children in need, preparing them to be the leaders of tomorrow.'),
  Ngo(id: '3', name: 'Pet Haven Shelter', category: 'Animal Welfare', area: 'Bangalore', need: 'Dog food, Blankets', rating: 4.9, imageUrl: '', description: 'Rescuing abandoned pets, providing medical care, and finding loving, permanent homes.'),
  Ngo(id: '4', name: 'Health for All', category: 'Health', area: 'Chennai', need: 'Medical supplies', rating: 4.3, imageUrl: '', description: 'Offering free health check-ups and essential medicines to remote and underserved populations.'),
];

final List<Donation> mockDonationHistory = [
  Donation(id: '1', ngoId: '2', donorId: 'donor1', ngoName: 'Future Leaders Academy', item: '₹1000 (Monetary)', date: 'Oct 15, 2024', status: 'Completed'),
  Donation(id: '2', ngoId: '1', donorId: 'donor1', ngoName: 'Clean Rivers Initiative', item: '5 Water Filters (In-kind)', date: 'Sep 28, 2024', status: 'Ongoing Pickup'),
  Donation(id: '3', ngoId: '3', donorId: 'donor1', ngoName: 'Pet Haven Shelter', item: '10 Kg Dog Food', date: 'Aug 01, 2024', status: 'Completed'),
];

final List<Pledge> mockAcceptedPledges = [
  Pledge(id: '1', title: 'Water Filters for Clean Rivers Initiative', ngoId: '1', ngoName: 'Clean Rivers Initiative', location: 'Mumbai'),
  Pledge(id: '2', title: 'Notebooks for Future Leaders Academy', ngoId: '2', ngoName: 'Future Leaders Academy', location: 'Delhi'),
];
