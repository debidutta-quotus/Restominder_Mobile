class OrdersConstants {
  static const Map<String, dynamic> ordersData = {
    "data": [
      {
        "_id": "687f833454efc35665848f16",
        "storeId": "2ae6bc6a-a5d0-4c27-9d53-fc5aa98f3c1a",
        "orderId": "ORD-1743492519194-227533dsasdf3",
        "orderDetails": [
          {
            "menuId": null,
            "price": 50.99,
            "quantity": 2,
            "_id": "687f833454efc35665848f17"
          }
        ],
        "orderStatus": "reject",
        "totalAmount": 50.99,
        "pickUpTime": "2025-03-06T18:30:00.000Z",
        "customerDetails": {
          "name": "John Doe",
          "phone": "+91 6371890342",
          "email": "john@gmail.com"
        }
      },
      {
        "_id": "687f834154efc35665848f19",
        "storeId": "2ae6bc6a-a5d0-4c27-9d53-fc5aa98f3c1a",
        "orderId": "ORD-1743492519194-227533dsasddf3",
        "orderDetails": [
          {
            "menuId": null,
            "price": 50.99,
            "quantity": 2,
            "_id": "687f834154efc35665848f1a"
          }
        ],
        "orderStatus": "reject",
        "totalAmount": 50.99,
        "pickUpTime": "2025-03-06T18:30:00.000Z",
        "customerDetails": {
          "name": "John Doe",
          "phone": "+91 6371890342",
          "email": "john@gmail.com"
        }
      },
      {
        "_id": "688761032e8b4f2444ea640c",
        "storeId": "2ae6bc6a-a5d0-4c27-9d53-fc5aa98f3c1a",
        "orderId": "ORD-d99224c5-1642-450f-9c1a-7e97aca571df",
        "orderDetails": [
          {
            "menuId": {
              "_id": "687887777c2d34b1070e1281",
              "name": "Chicken Tikka"
            },
            "price": 45.00,
            "quantity": 1,
            "_id": "688761032e8b4f2444ea640d"
          },
          {
            "menuId": {
              "_id": "688758d12e8b4f2444ea6338",
              "name": "Mutton Biryani"
            },
            "price": 65.00,
            "quantity": 1,
            "_id": "688761032e8b4f2444ea640e"
          }
        ],
        "orderStatus": "pending",
        "totalAmount": 110.00,
        "pickUpTime": "2025-01-30T15:30:00.000Z",
        "customerDetails": {
          "name": "Sarah Johnson",
          "phone": "+91 9876543210",
          "email": "sarah@gmail.com"
        }
      },
      {
        "_id": "688761092e8b4f2444ea6414",
        "storeId": "2ae6bc6a-a5d0-4c27-9d53-fc5aa98f3c1a",
        "orderId": "ORD-c4e0c7f0-921d-4796-9f24-23c36d5b73d7",
        "orderDetails": [
          {
            "menuId": {
              "_id": "687887777c2d34b1070e1281",
              "name": "Veg Biryani"
            },
            "price": 35.00,
            "quantity": 2,
            "_id": "688761092e8b4f2444ea6415"
          }
        ],
        "orderStatus": "pending",
        "totalAmount": 70.00,
        "pickUpTime": "2025-01-30T16:00:00.000Z",
        "customerDetails": {
          "name": "Mike Wilson",
          "phone": "+91 8765432109",
          "email": "mike@gmail.com"
        }
      },
      {
        "_id": "6888780a2e8b4f2444ea6afb",
        "storeId": "2ae6bc6a-a5d0-4c27-9d53-fc5aa98f3c1a",
        "orderId": "ORD-cdfcf7ed-f6c8-496f-8147-1bd5d94f92da",
        "orderDetails": [
          {
            "menuId": {
              "_id": "687887777c2d34b1070e1281",
              "name": "Chicken Curry"
            },
            "price": 55.00,
            "quantity": 1,
            "_id": "6888780a2e8b4f2444ea6afc"
          }
        ],
        "orderStatus": "dispatched",
        "totalAmount": 55.00,
        "pickUpTime": "2025-01-29T12:30:00.000Z",
        "customerDetails": {
          "name": "Emma Davis",
          "phone": "+91 7654321098",
          "email": "emma@gmail.com"
        }
      },
      {
        "_id": "6888780c2e8b4f2444ea6afe",
        "storeId": "2ae6bc6a-a5d0-4c27-9d53-fc5aa98f3c1a",
        "orderId": "ORD-1debf9a9-9f0f-4752-b2c0-f33fb58f948a",
        "orderDetails": [
          {
            "menuId": {
              "_id": "688758d12e8b4f2444ea6338",
              "name": "Fish Curry"
            },
            "price": 80.00,
            "quantity": 1,
            "_id": "6888780c2e8b4f2444ea6aff"
          }
        ],
        "orderStatus": "dispatched",
        "totalAmount": 80.00,
        "pickUpTime": "2025-01-28T14:15:00.000Z",
        "customerDetails": {
          "name": "Alex Brown",
          "phone": "+91 6543210987",
          "email": "alex@gmail.com"
        }
      },
      {
        "_id": "688f5cca2e8b4f2444ea712d",
        "storeId": "2ae6bc6a-a5d0-4c27-9d53-fc5aa98f3c1a",
        "orderId": "ORD-6f3fbefc-59aa-4d9e-9c35-52703aaed9ea",
        "orderDetails": [
          {
            "menuId": {
              "_id": "687887777c2d34b1070e1281",
              "name": "Veg Biryani"
            },
            "price": 30.5,
            "quantity": 1,
            "_id": "688f5cca2e8b4f2444ea712e"
          },
          {
            "menuId": {
              "_id": "688758d12e8b4f2444ea6338",
              "name": "Chicken Tikka"
            },
            "price": 45,
            "quantity": 3,
            "_id": "688f5cca2e8b4f2444ea712f"
          }
        ],
        "orderStatus": "ready",
        "totalAmount": 165.5,
        "pickUpTime": "2025-01-30T13:19:50.926Z",
        "customerDetails": {
          "name": "Lisa Garcia",
          "phone": "+91 5432109876",
          "email": "lisa@gmail.com"
        }
      }
    ]
  };

  // Helper method to get orders by status
  static List<Map<String, dynamic>> getOrdersByStatus(String status) {
    final orders = ordersData['data'] as List<Map<String, dynamic>>;
    return orders.where((order) => order['orderStatus'] == status).toList();
  }

  // Get pending orders (for new orders tab)
  static List<Map<String, dynamic>> getPendingOrders() {
    return getOrdersByStatus('pending');
  }

  // Get accepted orders (for accepted orders tab)
  static List<Map<String, dynamic>> getAcceptedOrders() {
    return getOrdersByStatus('ready');
  }

  // Get historical orders (dispatched and rejected)
  static List<Map<String, dynamic>> getHistoricalOrders() {
    final orders = ordersData['data'] as List<Map<String, dynamic>>;
    return orders.where((order) => 
      order['orderStatus'] == 'dispatched' || 
      order['orderStatus'] == 'reject'
    ).toList();
  }

  // Get all orders
  static List<Map<String, dynamic>> getAllOrders() {
    return ordersData['data'] as List<Map<String, dynamic>>;
  }
}