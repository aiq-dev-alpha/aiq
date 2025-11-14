import 'package:flutter/material.dart';
import 'dart:io';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _captionController = TextEditingController();
  final PageController _pageController = PageController();

  List<String> selectedImages = [];
  String? selectedVideo;
  bool isLoading = false;
  int currentPage = 0;

  final List<String> sampleImages = [
    'https://example.com/gallery1.jpg',
    'https://example.com/gallery2.jpg',
    'https://example.com/gallery3.jpg',
    'https://example.com/gallery4.jpg',
    'https://example.com/gallery5.jpg',
    'https://example.com/gallery6.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          TextButton(
            onPressed: selectedImages.isNotEmpty || selectedVideo != null
                ? _sharePost
                : null,
            child: Text(
              'Share',
              style: TextStyle(
                color: selectedImages.isNotEmpty || selectedVideo != null
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Media selection area
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              child: selectedImages.isEmpty && selectedVideo == null
                  ? _buildGalleryView()
                  : _buildSelectedMediaView(),
            ),
          ),
          // Caption and options
          Expanded(
            flex: 2,
            child: _buildCaptionSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryView() {
    return Column(
      children: [
        // Camera/Gallery options
        Container(
          height: 80,
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _takePhoto,
                  child: Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, size: 24),
                        Text('Camera', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: _pickFromGallery,
                  child: Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo_library, size: 24),
                        Text('Gallery', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Sample gallery grid
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(2),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            itemCount: sampleImages.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _selectImage(sampleImages[index]),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.network(
                        sampleImages[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: Icon(Icons.image, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                    if (selectedImages.contains(sampleImages[index]))
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedMediaView() {
    return Column(
      children: [
        // Main image display
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemCount: selectedImages.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.all(8),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        selectedImages[index],
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: Icon(Icons.image, size: 50, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => _removeImage(index),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.close, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        // Image indicators
        if (selectedImages.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: selectedImages.asMap().entries.map((entry) {
              return Container(
                width: 8,
                height: 8,
                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentPage == entry.key
                      ? Theme.of(context).primaryColor
                      : Colors.grey[300],
                ),
              );
            }).toList(),
          ),
        // Thumbnail strip
        if (selectedImages.length > 1)
          Container(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: selectedImages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: currentPage == index
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        selectedImages[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildCaptionSection() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage('https://example.com/current_user_avatar.jpg'),
              ),
              SizedBox(width: 12),
              Text(
                'current_user',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 16),
          // Caption input
          Expanded(
            child: TextField(
              controller: _captionController,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: 'Write a caption...',
                border: InputBorder.none,
              ),
            ),
          ),
          // Additional options
          Row(
            children: [
              TextButton.icon(
                onPressed: _tagPeople,
                icon: Icon(Icons.person_add),
                label: Text('Tag People'),
              ),
              TextButton.icon(
                onPressed: _addLocation,
                icon: Icon(Icons.location_on),
                label: Text('Add Location'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _takePhoto() {
    // Simulate taking a photo
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Camera functionality would be implemented here')),
    );
  }

  void _pickFromGallery() {
    // Simulate picking from gallery
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gallery picker would be implemented here')),
    );
  }

  void _selectImage(String imageUrl) {
    setState(() {
      if (selectedImages.contains(imageUrl)) {
        selectedImages.remove(imageUrl);
      } else {
        if (selectedImages.length < 10) { // Instagram allows up to 10 images
          selectedImages.add(imageUrl);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Maximum 10 images allowed')),
          );
        }
      }
    });
  }

  void _removeImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
      if (currentPage >= selectedImages.length && selectedImages.isNotEmpty) {
        currentPage = selectedImages.length - 1;
        _pageController.animateToPage(
          currentPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _tagPeople() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 300,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Tag People',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage('https://example.com/friend1.jpg'),
                      ),
                      title: Text('friend_1'),
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('friend_1 tagged')),
                        );
                      },
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage('https://example.com/friend2.jpg'),
                      ),
                      title: Text('friend_2'),
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('friend_2 tagged')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addLocation() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 300,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Add Location',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search locations...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text('Central Park, New York'),
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Location added: Central Park')),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text('Times Square, New York'),
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Location added: Times Square')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _sharePost() async {
    setState(() {
      isLoading = true;
    });

    // Simulate uploading
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });

    // Navigate back to feed
    Navigator.pushNamedAndRemoveUntil(context, '/feed', (route) => false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Post shared successfully!')),
    );
  }

  @override
  void dispose() {
    _captionController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}