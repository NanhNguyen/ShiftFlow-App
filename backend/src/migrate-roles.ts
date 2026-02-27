import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { getModelToken } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Role } from './users/schemas/role.schema';
import { User, UserRole } from './users/schemas/user.schema';

async function bootstrap() {
    const app = await NestFactory.createApplicationContext(AppModule);
    const roleModel = app.get<Model<Role>>(getModelToken(Role.name));
    const userModel = app.get<Model<User>>(getModelToken(User.name));

    const roles = [
        { _id: new Types.ObjectId('69649755edf9b4ac54f3c596'), name: 'INTERN' },
        { _id: new Types.ObjectId('69649765edf9b4ac54f3c598'), name: 'MANAGER' },
        { _id: new Types.ObjectId('6964978cedf9b4ac54f3c59a'), name: 'HR' }
    ];

    console.log('--- Syncing Roles ---');
    for (const r of roles) {
        await roleModel.findByIdAndUpdate(r._id, r, { upsert: true });
        console.log(`Synced Role: ${r.name} (${r._id})`);
    }

    console.log('\n--- Migrating Users ---');
    const users = await userModel.find();
    for (const user of users) {
        let targetRoleId: Types.ObjectId | null = null;

        // Determine role ID based on current role string or existing role_id
        const currentRole = user.role;
        const currentRoleId = user.role_id?.toString();

        if (currentRoleId === '69649755edf9b4ac54f3c596' || currentRole === UserRole.INTERN) {
            targetRoleId = roles[0]._id;
        } else if (currentRoleId === '69649765edf9b4ac54f3c598' || currentRole === UserRole.MANAGER) {
            targetRoleId = roles[1]._id;
        } else if (currentRoleId === '6964978cedf9b4ac54f3c59a' || currentRole === UserRole.HR) {
            targetRoleId = roles[2]._id;
        }

        if (targetRoleId) {
            user.role_id = targetRoleId;
            // Also ensure the 'role' string is correct
            user.role = currentRole || (targetRoleId.equals(roles[0]._id) ? UserRole.INTERN : (targetRoleId.equals(roles[1]._id) ? UserRole.MANAGER : UserRole.HR));
            await user.save();
            console.log(`Updated User: ${user.email} -> Role: ${user.role}`);
        } else {
            console.log(`Skipping User: ${user.email} (No recognizable role)`);
        }
    }

    console.log('\n✅ Migration complete!');
    await app.close();
}

bootstrap();
