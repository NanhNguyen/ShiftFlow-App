import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Notification, NotificationDocument } from './schemas/notification.schema';
import { User } from '../users/schemas/user.schema';
import { WebPushService } from './web-push.service';

@Injectable()
export class NotificationsService {
    constructor(
        @InjectModel(Notification.name)
        private notificationModel: Model<NotificationDocument>,
        @InjectModel(User.name)
        private userModel: Model<User>,
        private readonly webPushService: WebPushService,
    ) { }

    async create(userId: string, title: string, message: string, type: string, sourceId?: string): Promise<Notification> {
        // 1. Save to database
        const notification = new this.notificationModel({
            user_id: userId,
            title,
            message,
            type,
            sourceId,
        });
        const saved = await notification.save();

        // 2. Send Real-time Web Push notification
        try {
            const user = await this.userModel.findById(userId).exec();
            if (user && user.pushSubscriptions && user.pushSubscriptions.length > 0) {
                const payload = {
                    title,
                    body: message,
                    data: {
                        type,
                        sourceId,
                        url: type === 'ANNOUNCEMENT' ? '/announcements' : '/notifications',
                    },
                };

                // Send to all subscriptions for this user
                await Promise.all(
                    user.pushSubscriptions.map(sub =>
                        this.webPushService.sendNotification(sub, payload)
                    )
                );
            }
        } catch (pushError) {
            console.error('Failed to send push notification:', pushError);
        }

        return saved;
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

    async removeBySourceId(sourceId: string): Promise<void> {
        await this.notificationModel.deleteMany({ sourceId }).exec();
    }
}
