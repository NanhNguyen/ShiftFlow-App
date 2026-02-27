import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { getModelToken } from '@nestjs/mongoose';
import { Model } from 'mongoose';

async function bootstrap() {
    const app = await NestFactory.createApplicationContext(AppModule);

    try {
        console.log('--- Đang kiểm tra kết nối và cấu trúc User ---');
        const userModel = app.get<Model<any>>(getModelToken('User'));

        const sampleUser = await userModel.findOne().exec();

        if (sampleUser) {
            console.log('✅ Tìm thấy User mẫu:');
            console.log(JSON.stringify(sampleUser.toObject(), null, 2));
        } else {
            console.log('❌ Kết nối thành công nhưng không tìm thấy User nào trong collection.');

            // In ra tên collection đang được map
            console.log('Collection name:', userModel.collection.name);
        }
    } catch (error) {
        console.error('❌ Lỗi kết nối:', error.message);
    } finally {
        await app.close();
    }
}

bootstrap();
