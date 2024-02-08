import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/file_api.dart';

class MemoriesScreen extends StatefulWidget {
  const MemoriesScreen({super.key});

  @override
  State<MemoriesScreen> createState() => _MemoriesScreenState();
}

class _MemoriesScreenState extends State<MemoriesScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Memories"),
        centerTitle: true,
        elevation: 1,
      ),
      body: FutureBuilder(
          future: FileApi().fetchAllMemories(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length == 0) {
                return const Center(
                  child: Text("No memories uploaded yet"),
                );
              }
              return GridView.builder(
                  itemCount: snapshot.data.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(snapshot.data[index]),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.download),
                          onPressed: () async {
                            try {
                              setState(() {
                                _isLoading = true;
                              });
                              await FileApi()
                                  .downloadImage(snapshot.data[index]);

                              if (context.mounted) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Image Downloaded to Gallery"),
                                  backgroundColor: Colors.green,
                                ));
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text("$e"),
                                        backgroundColor: Colors.red));
                              }
                            } finally {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                        ),
                      ],
                    );
                  });
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButton: _isLoading
          ? const CircularProgressIndicator()
          : FloatingActionButton(
              onPressed: () async {
                XFile? pickImage =
                    await ImagePicker().pickImage(source: ImageSource.gallery);

                if (pickImage != null) {
                  File? file = File(pickImage.path);
                  try {
                    setState(() {
                      _isLoading = true;
                    });
                    await FileApi().uploadImage(file);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Image Uploaded Successfully"),
                        backgroundColor: Colors.green,
                      ));
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("$e"), backgroundColor: Colors.red));
                    }
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("No Image Selected")));
                  }
                }
              },
              child: const Icon(Icons.upload),
            ),
    );
  }
}
