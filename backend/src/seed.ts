import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { UsersService } from './users/users.service';
import { UserRole } from './users/schemas/user.schema';

async function bootstrap() {
    const app = await NestFactory.createApplicationContext(AppModule);
    const usersService = app.get(UsersService);

    console.log('Seeding data...');

    // Create Manager
    const manager = await usersService.findByEmail('admin@company.com');
    if (!manager) {
        await usersService.create({
            email: 'admin@company.com',
            password_hash: 'password123',
            name: 'System Administrator',
            role: UserRole.MANAGER,
        });
        console.log('Manager user created: admin@company.com / password123');
    }

    // Create Intern
    const intern = await usersService.findByEmail('intern@company.com');
    if (!intern) {
        await usersService.create({
            email: 'intern@company.com',
            password_hash: 'password123',
            name: 'John Intern',
            role: UserRole.INTERN,
        });
        console.log('Intern user created: intern@company.com / password123');
    }

    console.log('Seed completed!');
    await app.close();
}

bootstrap();
