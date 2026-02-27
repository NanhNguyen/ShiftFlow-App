import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { UsersService } from './users/users.service';
import { Types } from 'mongoose';

async function bootstrap() {
    const app = await NestFactory.createApplicationContext(AppModule);
    const usersService = app.get(UsersService);

    const usersToCreate = [
        {
            name: 'Test2',
            email: 'test2@gmail.com',
            password: '123456',
            roleId: '69649755edf9b4ac54f3c596'
        },
        {
            name: 'Test3',
            email: 'test3@gmail.com',
            password: '123456',
            roleId: '69649755edf9b4ac54f3c596'
        },
        {
            name: 'HR',
            email: 'hr@gmail.com',
            password: '123456',
            roleId: '6964978cedf9b4ac54f3c59a'
        }
    ];

    for (const u of usersToCreate) {
        console.log(`--- Processing user: ${u.email} ---`);
        const existing = await usersService.findByEmail(u.email);
        if (existing) {
            console.log(`User ${u.email} already exists. Skipping.`);
            continue;
        }

        await usersService.create({
            email: u.email,
            password_hash: u.password, // Will be hashed in service
            name: u.name,
            role_id: new Types.ObjectId(u.roleId) as any
        });
        console.log(`✅ Created ${u.name} (${u.email})`);
    }

    await app.close();
}

bootstrap();
