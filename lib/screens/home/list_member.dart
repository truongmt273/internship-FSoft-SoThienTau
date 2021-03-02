import 'package:brew_crew/models/contact.dart';
import 'package:flutter/material.dart';

class ListMember extends StatefulWidget {
  final List<Contact> listContacts;

  ListMember(this.listContacts);

  @override
  _ListMemberState createState() => _ListMemberState();
}

class _ListMemberState extends State<ListMember> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.listContacts.length,
        itemBuilder: (ctx, index) {
          return Card(
            elevation: 2,
            child: ListTile(
              title: Text(widget.listContacts[index].name,
                  style: TextStyle(fontSize: 20)),
              trailing: IconButton(
                icon: Icon(widget.listContacts[index].isSelected
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked),
                onPressed: () {
                  setState(() {
                    widget.listContacts[index].isSelected = !widget.listContacts[index].isSelected;
                  });
                },
              ),
            ),
          );
        });
  }
}
