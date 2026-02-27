import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { UsersService } from './users/users.service';
import { Types } from 'mongoose';

async function bootstrap() {
    const app = await NestFactory.createApplicationContext(AppModule);
    const usersService = app.get(UsersService);

    const email = 'manager@gmail.com';
    const managerRoleId = '69649765edf9b4ac54f3c598';

    console.log(`--- Fixing role for: ${email} ---`);
    const user = await usersService.findByEmail(email);
    if (user) {
        // cast to any to bypass strict TS check for a quick fix script
        await (usersService as any).update(user['_id'].toString(), {
            role_id: new Types.ObjectId(managerRoleId)
        });
        console.log('✅ Role fixed to MANAGER');
    } else {
        console.log('User not found');
    }

    await app.close();
}

bootstrap();
