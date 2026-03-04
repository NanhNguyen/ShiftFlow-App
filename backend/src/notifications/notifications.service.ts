import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Notification, NotificationDocument } from './schemas/notification.schema';

@Injectable()
export class NotificationsService {
    constructor(
        @InjectModel(Notification.name)
        private notificationModel: Model<NotificationDocument>,
    ) { }

    async create(userId: string, title: string, message: string, type: string): Promise<Notification> {
        const notification = new this.notificationModel({
            user_id: userId,
            title,
            message,
            type,
        });
        return notification.save();
    }

    async findAllByUser(userId: string): Promise<Notification[]> {
        return this.notificationModel
            .find({ user_id: userId as any })
            .sort({ createdAt: -1 })
            .exec();
    }

    async markAsRead(id: string): Promise<Notification | null> {
        return this.notificationModel
            .findByIdAndUpdate(id, { is_read: true }, { new: true })
            .exec();
    }

    async markAllAsRead(userId: string): Promise<void> {
        await this.notificationModel
            .updateMany({ user_id: userId as any, is_read: false }, { is_read: true })
            .exec();
    }
}
