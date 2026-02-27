import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Schema as MongooseSchema } from 'mongoose';

export enum RequestType {
    WORK = 'WORK',
    LEAVE = 'LEAVE',
}

export enum RequestStatus {
    PENDING = 'PENDING',
    APPROVED = 'APPROVED',
    REJECTED = 'REJECTED',
}

export enum RecurrenceFrequency {
    NONE = 'NONE',
    DAILY = 'DAILY',
    WEEKLY = 'WEEKLY',
    MONTHLY = 'MONTHLY',
}

@Schema()
class Recurrence {
    @Prop({ enum: RecurrenceFrequency, default: RecurrenceFrequency.NONE })
    frequency: RecurrenceFrequency;

    @Prop([Number]) // 0-6 for Sunday-Saturday
    daysOfWeek: number[];

    @Prop()
    endDate: Date;
}

const RecurrenceSchema = SchemaFactory.createForClass(Recurrence);

@Schema({ timestamps: { createdAt: 'created_at', updatedAt: 'updated_at' }, collection: 'schedulerequests' })
export class ScheduleRequest extends Document {
    @Prop({ type: MongooseSchema.Types.ObjectId, ref: 'User', required: true })
    employee_id: MongooseSchema.Types.ObjectId;

    @Prop()
    weekday: string;

    @Prop()
    groupId: string;

    @Prop({ required: true })
    shift: string;

    @Prop({ default: false })
    is_recurring: boolean;

    @Prop({ required: true })
    start_date: Date;

    @Prop({ required: true })
    end_date: Date;

    @Prop({ type: RecurrenceSchema, default: () => ({ frequency: RecurrenceFrequency.NONE, daysOfWeek: [], endDate: null }) })
    recurrence: Recurrence;

    @Prop({ required: true, enum: RequestStatus, default: RequestStatus.PENDING })
    status: RequestStatus;

    @Prop({ required: true, enum: RequestType, default: RequestType.WORK })
    type: RequestType;

    @Prop({ type: MongooseSchema.Types.ObjectId, ref: 'User' })
    approvedBy: MongooseSchema.Types.ObjectId;

    @Prop()
    title: string;

    @Prop()
    description: string;
}

export const ScheduleRequestSchema = SchemaFactory.createForClass(ScheduleRequest);
