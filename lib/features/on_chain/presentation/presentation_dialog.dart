import 'package:bitcoin_nft_ui/features/on_chain/data/upload_inscription.dart';
import 'package:flutter/material.dart';

void showSuccessfulDialogAboutCreatingInscription(String title, 
    SendResponse res, BuildContext context) {
  Widget okButton = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text("OK"));
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: SelectableText(
        "Your commit transaction id is ${res.commitTxId}\nYour reveal transaction id is ${res.revealTxId}"),
    actions: [okButton],
  );

  showDialog(context: context, builder: (context) => alert);
}

void showFailedDialogAboutCreatingInscription(
    SendResponse res, BuildContext context) {
  Widget okButton = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text("OK"));
  AlertDialog alert = AlertDialog(
    title: const Text("Upload inscription failed"),
    content: const Text("Failed to create inscription"),
    actions: [okButton],
  );

  showDialog(context: context, builder: (context) => alert);
}
