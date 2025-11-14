import 'package:flutter/material.dart';

class ShippingAddressScreen extends StatefulWidget {
  @override
  _ShippingAddressScreenState createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  List<ShippingAddress> addresses = [
    ShippingAddress(
      id: '1',
      name: 'John Doe',
      address: '123 Main Street',
      city: 'San Francisco',
      state: 'CA',
      zipCode: '94102',
      phone: '(555) 123-4567',
      isDefault: true,
      type: 'Home',
    ),
    ShippingAddress(
      id: '2',
      name: 'John Doe',
      address: '456 Business Ave, Suite 100',
      city: 'San Francisco',
      state: 'CA',
      zipCode: '94105',
      phone: '(555) 987-6543',
      isDefault: false,
      type: 'Work',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shipping Addresses'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                return _buildAddressCard(addresses[index]);
              },
            ),
          ),
          _buildAddAddressButton(),
        ],
      ),
    );
  }

  Widget _buildAddressCard(ShippingAddress address) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: address.type.toLowerCase() == 'home' ? Colors.green[100] : Colors.blue[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    address.type,
                    style: TextStyle(
                      color: address.type.toLowerCase() == 'home' ? Colors.green[800] : Colors.blue[800],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (address.isDefault) ...[
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Default',
                      style: TextStyle(
                        color: Colors.orange[800],
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                Spacer(),
                PopupMenuButton<String>(
                  onSelected: (value) => _handleMenuAction(value, address),
                  itemBuilder: (context) => [
                    if (!address.isDefault)
                      PopupMenuItem(value: 'default', child: Text('Set as Default')),
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              address.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(address.address),
            Text('${address.city}, ${address.state} ${address.zipCode}'),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                SizedBox(width: 4),
                Text(
                  address.phone,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddAddressButton() {
    return Container(
      padding: EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            _showAddAddressForm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'ADD NEW ADDRESS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleMenuAction(String action, ShippingAddress address) {
    switch (action) {
      case 'default':
        setState(() {
          for (var addr in addresses) {
            addr.isDefault = false;
          }
          address.isDefault = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Set as default address')),
        );
        break;
      case 'edit':
        _showEditAddressForm(address);
        break;
      case 'delete':
        _showDeleteConfirmation(address);
        break;
    }
  }

  void _showAddAddressForm() {
    _showAddressForm();
  }

  void _showEditAddressForm(ShippingAddress address) {
    _showAddressForm(address: address);
  }

  void _showAddressForm({ShippingAddress? address}) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController(text: address?.name ?? '');
    final _addressController = TextEditingController(text: address?.address ?? '');
    final _cityController = TextEditingController(text: address?.city ?? '');
    final _zipController = TextEditingController(text: address?.zipCode ?? '');
    final _phoneController = TextEditingController(text: address?.phone ?? '');
    String selectedState = address?.state ?? 'CA';
    String selectedType = address?.type ?? 'Home';
    bool isDefault = address?.isDefault ?? false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address == null ? 'Add Address' : 'Edit Address',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 24),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.isEmpty == true ? 'Required' : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.isEmpty == true ? 'Required' : null,
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _cityController,
                          decoration: InputDecoration(
                            labelText: 'City',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => value?.isEmpty == true ? 'Required' : null,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedState,
                          decoration: InputDecoration(
                            labelText: 'State',
                            border: OutlineInputBorder(),
                          ),
                          items: ['CA', 'NY', 'TX', 'FL', 'WA']
                              .map((state) => DropdownMenuItem(value: state, child: Text(state)))
                              .toList(),
                          onChanged: (value) => selectedState = value!,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _zipController,
                          decoration: InputDecoration(
                            labelText: 'ZIP',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) => value?.isEmpty == true ? 'Required' : null,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) => value?.isEmpty == true ? 'Required' : null,
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    decoration: InputDecoration(
                      labelText: 'Address Type',
                      border: OutlineInputBorder(),
                    ),
                    items: ['Home', 'Work', 'Other']
                        .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                        .toList(),
                    onChanged: (value) => selectedType = value!,
                  ),
                  SizedBox(height: 16),
                  CheckboxListTile(
                    value: isDefault,
                    onChanged: (value) => isDefault = value!,
                    title: Text('Set as default address'),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() == true) {
                              if (address == null) {
                                // Add new address
                                setState(() {
                                  if (isDefault) {
                                    for (var addr in addresses) {
                                      addr.isDefault = false;
                                    }
                                  }
                                  addresses.add(ShippingAddress(
                                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                                    name: _nameController.text,
                                    address: _addressController.text,
                                    city: _cityController.text,
                                    state: selectedState,
                                    zipCode: _zipController.text,
                                    phone: _phoneController.text,
                                    isDefault: isDefault,
                                    type: selectedType,
                                  ));
                                });
                              } else {
                                // Edit existing address
                                setState(() {
                                  if (isDefault) {
                                    for (var addr in addresses) {
                                      addr.isDefault = false;
                                    }
                                  }
                                  address.name = _nameController.text;
                                  address.address = _addressController.text;
                                  address.city = _cityController.text;
                                  address.state = selectedState;
                                  address.zipCode = _zipController.text;
                                  address.phone = _phoneController.text;
                                  address.isDefault = isDefault;
                                  address.type = selectedType;
                                });
                              }
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Address saved successfully')),
                              );
                            }
                          },
                          child: Text(address == null ? 'Add' : 'Save'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(ShippingAddress address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Address'),
        content: Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                addresses.remove(address);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Address deleted')),
              );
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class ShippingAddress {
  final String id;
  String name;
  String address;
  String city;
  String state;
  String zipCode;
  String phone;
  bool isDefault;
  String type;

  ShippingAddress({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.phone,
    required this.isDefault,
    required this.type,
  });
}