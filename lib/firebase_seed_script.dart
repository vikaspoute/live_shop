import 'package:cloud_firestore/cloud_firestore.dart';

/// Quick Firebase seeder without JSON files
class QuickFirebaseSeeder {
  final FirebaseFirestore firestore;

  QuickFirebaseSeeder(this.firestore);

  Future<void> seedAll() async {
    print('🌱 Starting Firebase seeding...');

    try {
      await seedSessions();
      await seedProducts();
      await seedMessages();

      print('✅ Firebase seeding completed successfully!');
    } catch (e) {
      print('❌ Error seeding Firebase: $e');
      rethrow;
    }
  }

  Future<void> seedSessions() async {
    print('📺 Seeding sessions...');

    final sessions = [
      {
        'sellerId': 'seller_001',
        'sellerName': 'TechGuru Store',
        'sellerImage': 'https://ui-avatars.com/api/?name=TechGuru+Store&background=4F46E5&color=fff',
        'title': 'Flash Sale: Premium Electronics',
        'description': 'Amazing deals on headphones, speakers, and smart devices. Don\'t miss out!',
        'isLive': true,
        'viewerCount': 1250,
        'startedAt': Timestamp.now(),
        'thumbnailUrl': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800',
      },
      {
        'sellerId': 'seller_002',
        'sellerName': 'Fashion Hub',
        'sellerImage': 'https://ui-avatars.com/api/?name=Fashion+Hub&background=EC4899&color=fff',
        'title': 'Summer Collection Launch',
        'description': 'Exclusive first look at our new summer clothing line with special discounts',
        'isLive': true,
        'viewerCount': 850,
        'startedAt': Timestamp.now(),
        'thumbnailUrl': 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=800',
      },
      {
        'sellerId': 'seller_003',
        'sellerName': 'Home & Living',
        'sellerImage': 'https://ui-avatars.com/api/?name=Home+Living&background=10B981&color=fff',
        'title': 'Smart Home Essentials',
        'description': 'Transform your home with our curated selection of smart home devices',
        'isLive': true,
        'viewerCount': 620,
        'startedAt': Timestamp.now(),
        'thumbnailUrl': 'https://images.unsplash.com/photo-1558002038-1055907df827?w=800',
      },
      {
        'sellerId': 'seller_004',
        'sellerName': 'Beauty Box',
        'sellerImage': 'https://ui-avatars.com/api/?name=Beauty+Box&background=F59E0B&color=fff',
        'title': 'Skincare Secrets Revealed',
        'description': 'Live demo of our best-selling skincare products with expert tips',
        'isLive': true,
        'viewerCount': 2100,
        'startedAt': Timestamp.now(),
        'thumbnailUrl': 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=800',
      },
      {
        'sellerId': 'seller_005',
        'sellerName': 'Fitness Pro',
        'sellerImage': 'https://ui-avatars.com/api/?name=Fitness+Pro&background=EF4444&color=fff',
        'title': 'Workout Gear & Supplements',
        'description': 'Everything you need for your fitness journey',
        'isLive': true,
        'viewerCount': 450,
        'startedAt': Timestamp.now(),
        'thumbnailUrl': 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=800',
      },
    ];

    for (var i = 0; i < sessions.length; i++) {
      await firestore.collection('sessions').doc('session_00${i + 1}').set(sessions[i]);
    }

    print('✅ Seeded ${sessions.length} sessions');
  }

  Future<void> seedProducts() async {
    print('📦 Seeding products...');

    final products = [
      {
        'name': 'Premium Wireless Headphones',
        'description': 'Active Noise Cancellation, 30hr battery life, premium sound quality',
        'price': 199.99,
        'imageUrl': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
        'category': 'Electronics',
        'stock': 50,
        'sessionId': 'session_001',
      },
      {
        'name': 'Bluetooth Smart Speaker',
        'description': '360° sound, voice assistant, waterproof design',
        'price': 79.99,
        'imageUrl': 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=400',
        'category': 'Electronics',
        'stock': 100,
        'sessionId': 'session_001',
      },
      {
        'name': 'Smartwatch Pro',
        'description': 'Fitness tracking, heart rate monitor, GPS, 7-day battery',
        'price': 299.99,
        'imageUrl': 'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?w=400',
        'category': 'Electronics',
        'stock': 35,
        'sessionId': 'session_001',
      },
      {
        'name': 'Wireless Earbuds',
        'description': 'True wireless, IPX7 waterproof, 24hr battery with case',
        'price': 89.99,
        'imageUrl': 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=400',
        'category': 'Electronics',
        'stock': 110,
        'sessionId': 'session_001',
      },
      {
        'name': 'Designer Summer Dress',
        'description': 'Lightweight cotton, floral pattern, perfect for summer',
        'price': 89.99,
        'imageUrl': 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400',
        'category': 'Fashion',
        'stock': 75,
        'sessionId': 'session_002',
      },
      {
        'name': 'Classic Denim Jacket',
        'description': 'Premium denim, versatile style, comfortable fit',
        'price': 119.99,
        'imageUrl': 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400',
        'category': 'Fashion',
        'stock': 60,
        'sessionId': 'session_002',
      },
      {
        'name': 'Smart LED Bulb Set (4-Pack)',
        'description': 'WiFi enabled, 16 million colors, voice control compatible',
        'price': 49.99,
        'imageUrl': 'https://images.unsplash.com/photo-1550985543-49bee3167284?w=400',
        'category': 'Home & Living',
        'stock': 120,
        'sessionId': 'session_003',
      },
      {
        'name': 'Robot Vacuum Cleaner',
        'description': 'Auto-charging, app control, HEPA filter, mapping technology',
        'price': 349.99,
        'imageUrl': 'https://images.unsplash.com/photo-1558317374-067fb5f30001?w=400',
        'category': 'Home & Living',
        'stock': 25,
        'sessionId': 'session_003',
      },
      {
        'name': 'Smart Thermostat',
        'description': 'Energy saving, remote control, learning algorithm',
        'price': 179.99,
        'imageUrl': 'https://images.unsplash.com/photo-1545259741-2ea3ebf61fa3?w=400',
        'category': 'Home & Living',
        'stock': 40,
        'sessionId': 'session_003',
      },
      {
        'name': 'Vitamin C Serum',
        'description': 'Brightening formula, anti-aging, reduces dark spots',
        'price': 34.99,
        'imageUrl': 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=400',
        'category': 'Beauty',
        'stock': 200,
        'sessionId': 'session_004',
      },
      {
        'name': 'Hydrating Face Cream',
        'description': '24-hour moisture, hyaluronic acid, suitable for all skin types',
        'price': 29.99,
        'imageUrl': 'https://images.unsplash.com/photo-1556229010-6c3f2c9ca5f8?w=400',
        'category': 'Beauty',
        'stock': 150,
        'sessionId': 'session_004',
      },
      {
        'name': 'Adjustable Dumbbell Set',
        'description': '5-52.5 lbs per dumbbell, space-saving design',
        'price': 399.99,
        'imageUrl': 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=400',
        'category': 'Fitness',
        'stock': 30,
        'sessionId': 'session_005',
      },
      {
        'name': 'Protein Powder (2lb)',
        'description': 'Whey isolate, 25g protein per serving, chocolate flavor',
        'price': 49.99,
        'imageUrl': 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?w=400',
        'category': 'Fitness',
        'stock': 80,
        'sessionId': 'session_005',
      },
      {
        'name': 'Yoga Mat Premium',
        'description': 'Non-slip, eco-friendly, 6mm thick, includes carrying strap',
        'price': 39.99,
        'imageUrl': 'https://images.unsplash.com/photo-1601925260368-ae2f83cf8b7f?w=400',
        'category': 'Fitness',
        'stock': 95,
        'sessionId': 'session_005',
      },
    ];

    for (var i = 0; i < products.length; i++) {
      await firestore.collection('products').doc('product_${(i + 1).toString().padLeft(3, '0')}').set(products[i]);
    }

    print('✅ Seeded ${products.length} products');
  }

  Future<void> seedMessages() async {
    print('💬 Seeding messages...');

    final sessionIds = ['session_001', 'session_002', 'session_003', 'session_004', 'session_005'];
    int totalMessages = 0;

    for (var sessionId in sessionIds) {
      final messages = [
        {
          'sessionId': sessionId,
          'userId': 'user_001',
          'userName': 'Sarah Johnson',
          'userImage': 'https://ui-avatars.com/api/?name=Sarah+Johnson&background=4F46E5&color=fff',
          'text': 'Just joined! Excited to see the deals!',
          'timestamp': Timestamp.now(),
          'type': 'user',
        },
        {
          'sessionId': sessionId,
          'userId': 'user_002',
          'userName': 'Mike Chen',
          'userImage': 'https://ui-avatars.com/api/?name=Mike+Chen&background=EC4899&color=fff',
          'text': 'Love this session! 😍',
          'timestamp': Timestamp.now(),
          'type': 'user',
        },
        {
          'sessionId': sessionId,
          'userId': 'user_003',
          'userName': 'Emma Wilson',
          'userImage': 'https://ui-avatars.com/api/?name=Emma+Wilson&background=10B981&color=fff',
          'text': 'Added to cart! 🛒',
          'timestamp': Timestamp.now(),
          'type': 'user',
        },
        {
          'sessionId': sessionId,
          'userId': 'user_004',
          'userName': 'John Smith',
          'userImage': 'https://ui-avatars.com/api/?name=John+Smith&background=F59E0B&color=fff',
          'text': 'What colors are available?',
          'timestamp': Timestamp.now(),
          'type': 'user',
        },
        {
          'sessionId': sessionId,
          'userId': 'user_005',
          'userName': 'Lisa Anderson',
          'userImage': 'https://ui-avatars.com/api/?name=Lisa+Anderson&background=EF4444&color=fff',
          'text': 'Great price! Just ordered mine!',
          'timestamp': Timestamp.now(),
          'type': 'user',
        },
      ];

      for (var i = 0; i < messages.length; i++) {
        await firestore
            .collection('sessions')
            .doc(sessionId)
            .collection('messages')
            .doc('msg_${sessionId}_${i + 1}')
            .set(messages[i]);
      }

      totalMessages += messages.length;
      print('  ✅ Seeded ${messages.length} messages for $sessionId');
    }

    print('✅ Seeded $totalMessages total messages');
  }

  Future<void> clearAll() async {
    print('🗑️  Clearing all data...');

    await _clearCollection('sessions');
    await _clearCollection('products');

    print('✅ All data cleared');
  }

  Future<void> _clearCollection(String collectionPath) async {
    final snapshot = await firestore.collection(collectionPath).get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }

    print('  ✅ Cleared $collectionPath collection');
  }
}

/// Use this function to seed Firebase - NO JSON FILES NEEDED
Future<void> quickSeedFirebase() async {
  try {
    print('\n🚀 Starting Quick Firebase Seed...\n');
    final seeder = QuickFirebaseSeeder(FirebaseFirestore.instance);
    await seeder.seedAll();
    print('\n🎉 All done! Check your Firebase Console.\n');
  } catch (e) {
    print('❌ Seeding Error: $e');
  }
}