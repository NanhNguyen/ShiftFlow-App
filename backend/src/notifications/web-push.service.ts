import { Injectable, OnModuleInit } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as webPush from 'web-push';

@Injectable()
export class WebPushService implements OnModuleInit {
    constructor(private readonly configService: ConfigService) { }

    onModuleInit() {
        const publicKey = this.configService.get<string>('VAPID_PUBLIC_KEY');
        const privateKey = this.configService.get<string>('VAPID_PRIVATE_KEY');

        if (publicKey && privateKey) {
            webPush.setVapidDetails(
                'mailto:admin@shiftflow.com',
                publicKey,
                privateKey,
            );
            console.log('WebPush Service initialized with VAPID keys.');
        } else {
            console.warn('VAPID keys not found in environment variables. WebPush will not work.');
        }
    }

    async sendNotification(subscription: any, payload: any): Promise<void> {
        try {
            await webPush.sendNotification(subscription, JSON.stringify(payload));
        } catch (error) {
            console.error('Error sending web push notification:', error);
            if (error.statusCode === 410 || error.statusCode === 404) {
                // Subscription has expired or is no longer valid
                // We should ideally remove it from the database, 
                // but we need userId for that. This service is low-level.
            }
        }
    }
}
