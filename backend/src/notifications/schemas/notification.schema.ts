import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Schema as MongooseSchema } from 'mongoose';
import { User } from '../../users/schemas/user.schema';

export type NotificationDocument = Notification & Document;

@Schema({ timestamps: true })
export class Notification {
    @Prop({ type: MongooseSchema.Types.ObjectId, ref: 'User', required: true })
    user_id: User;

    @Prop({ required: true })
    title: string;

    @Prop({ required: true })
    message: string;

    @Prop({ default: false })
    is_read: boolean;

    @Prop({ required: true })
    type: string;

    @Prop({ type: MongooseSchema.Types.ObjectId, default: null })
    sourceId: string;
}

export const NotificationSchema = SchemaFactory.createForClass(Notification);
