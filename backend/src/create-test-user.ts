import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { UsersService } from './users/users.service';
import { UserRole } from './users/schemas/user.schema';

async function bootstrap() {
    const app = await NestFactory.createApplicationContext(AppModule);
    const usersService = app.get(UsersService);

    const email = 'test@gmail.com';
    const password = 'password123';
    const name = 'Admin Test';

    console.log(`--- Creating user: ${email} ---`);

    const existing = await usersService.findByEmail(email);
    if (existing) {
        console.log('User already exists, updating password...');
        existing.password_hash = password; // The create/save logic in UsersService will hash it
        // Note: Actually my current UsersService.create hashes it, but saving an existing one might not. 
        // Let's just delete and recreate for certainty in this script.
        await (existing as any).deleteOne();
    }

    await usersService.create({
        email: email,
        password_hash: password, // This will be hashed inside UsersService.create
        name: name,
        role: UserRole.MANAGER,
    });

    console.log('✅ User created successfully!');
    console.log(`Email: ${email}`);
    console.log(`Password: ${password}`);

    await app.close();
}

bootstrap();
