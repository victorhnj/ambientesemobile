import 'package:flutter/material.dart';

void showDeleteConfirmation(BuildContext context, String companyName, VoidCallback onConfirmDelete) {
  showDialog(
    context: context,
    barrierDismissible: true, 
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), 
        contentPadding: EdgeInsets.all(16), 
        content: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 300, maxHeight: 200), // Control dialog size
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center, // Center align text within the content
            children: [
              Text(
                'Deseja mesmo deletar a empresa $companyName?',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Não será possível recuperar após a exclusão!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center-align the buttons
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red, // Solid red background for "Não" button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Não',
                      style: TextStyle(color: Colors.white), // White text for contrast
                    ),
                  ),
                  SizedBox(width: 8), // Space between the buttons
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      onConfirmDelete(); // Call the delete function
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFF0077C8), // Blue background for "Sim" button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Sim',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
