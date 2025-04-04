import 'package:spa_mobile/features/home/data/models/message_channel_model.dart';
import 'package:spa_mobile/features/home/domain/entities/channel.dart';

class ChannelModel extends Channel {
  final List<MessageChannelModel> messages;

  ChannelModel(
      {required super.id,
      required super.name,
      required super.appointmentId,
      required super.members,
      required super.admin,
      required this.messages});

  factory ChannelModel.fromJson(Map<String, dynamic> json) => ChannelModel(
        id: json["id"],
        name: json["name"],
        appointmentId: json["appointmentId"],
        members: List<String>.from(json["members"].map((x) => x)),
        admin: json["admin"],
        messages: (json['messages'] as List).map((x) => MessageChannelModel.fromJson(x)).toList(),
      );
}
