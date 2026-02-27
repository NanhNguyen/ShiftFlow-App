import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { getModelToken } from '@nestjs/mongoose';
import { Model } from 'mongoose';

async function bootstrap() {
    const app = await NestFactory.createApplicationContext(AppModule);

    try {
        console.log('--- Đang kiểm tra cấu trúc ScheduleRequest ---');
        const scheduleModel = app.get<Model<any>>(getModelToken('ScheduleRequest'));

        const sampleRequest = await scheduleModel.findOne().exec();

        if (sampleRequest) {
            console.log('✅ Tìm thấy ScheduleRequest mẫu:');
            console.log(JSON.stringify(sampleRequest.toObject(), null, 2));
        } else {
            console.log('❌ Không tìm thấy ScheduleRequest nào.');
        }
    } catch (error) {
        console.error('❌ Lỗi:', error.message);
    } finally {
        await app.close();
    }
}

bootstrap();
