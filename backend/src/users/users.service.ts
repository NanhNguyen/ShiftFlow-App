import { Injectable, UnauthorizedException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { User, UserRole } from './schemas/user.schema';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UsersService {
    constructor(@InjectModel(User.name) private userModel: Model<User>) { }

    private mapRoleIdToRole(roleId: any): UserRole {
        const id = roleId?.toString() || '';
        switch (id) {
            case '69649755edf9b4ac54f3c596':
                return UserRole.INTERN;
            case '69649765edf9b4ac54f3c598':
                return UserRole.MANAGER;
            case '6964978cedf9b4ac54f3c59a':
                return UserRole.HR;
            default:
                return UserRole.INTERN;
        }
    }

    async create(userData: Partial<User>): Promise<User> {
        if (!userData.password_hash) {
            throw new Error('Password is required');
        }
        const hashedPassword = await bcrypt.hash(userData.password_hash, 10);

        // Auto-assign role based on role_id if present
        if (userData.role_id) {
            userData.role = this.mapRoleIdToRole(userData.role_id);
        }

        const createdUser = new this.userModel({ ...userData, password_hash: hashedPassword });
        return createdUser.save();
    }

    async findByEmail(email: string): Promise<User | null> {
        const user = await this.userModel.findOne({ email }).exec();
        if (user && user.role_id) {
            user.role = this.mapRoleIdToRole(user.role_id);
        }
        return user;
    }

    async findById(id: string): Promise<User | null> {
        const user = await this.userModel.findById(id).exec();
        if (user && user.role_id) {
            user.role = this.mapRoleIdToRole(user.role_id);
        }
        return user;
    }

    async findAll(): Promise<User[]> {
        const users = await this.userModel.find().select('-password_hash').exec();
        return users.map(user => {
            if (user.role_id) {
                user.role = this.mapRoleIdToRole(user.role_id);
            }
            return user;
        });
    }

    async getManagers(): Promise<User[]> {
        const managers = await this.userModel.find({ role_id: '69649765edf9b4ac54f3c598' }).select('-password_hash').exec();
        return managers.map(user => {
            user.role = UserRole.MANAGER;
            return user;
        });
    }

    async findAllManagedBy(managerId: any): Promise<User[]> {
        const mgrIdStr = managerId.toString();
        console.log(`[findAllManagedBy] Querying interns for managerId: ${mgrIdStr}`);

        // Mongoose sometimes struggles with union types or 'any' if not explicitly cast
        // To be absolutely safe, let's fetch all interns and filter in memory if the query fails,
        // but let's try a direct query first.
        let users = await this.userModel.find({ managerId: mgrIdStr }).select('-password_hash').exec();

        if (users.length === 0) {
            // Fallback: try raw ObjectId if the string didn't work (though Mongoose casts strings to ObjectIds usually)
            users = await this.userModel.find({ managerId: managerId }).select('-password_hash').exec();
        }

        console.log(`[findAllManagedBy] Found ${users.length} interns.`);
        return users.map(user => {
            if (user.role_id) {
                user.role = this.mapRoleIdToRole(user.role_id);
            }
            return user;
        });
    }

    async update(id: string, updateData: Partial<User>): Promise<User | null> {
        if (updateData.role_id) {
            updateData.role = this.mapRoleIdToRole(updateData.role_id);
        }
        const user = await this.userModel.findByIdAndUpdate(id, updateData, { new: true }).exec();
        if (user && user.role_id) {
            user.role = this.mapRoleIdToRole(user.role_id);
        }
        return user;
    }

    async changePassword(id: string, oldPassword: string, newPassword: string): Promise<void> {
        const user = await this.userModel.findById(id).exec();
        if (!user) throw new UnauthorizedException('Không tìm thấy người dùng');

        const isMatch = await bcrypt.compare(oldPassword, user.password_hash);
        if (!isMatch) throw new UnauthorizedException('Mật khẩu cũ không chính xác');

        const hashedPassword = await bcrypt.hash(newPassword, 10);
        await this.userModel.findByIdAndUpdate(id, { password_hash: hashedPassword }).exec();
    }

    async addPushSubscription(userId: string, subscription: any): Promise<void> {
        await this.userModel.findByIdAndUpdate(userId, {
            $addToSet: { pushSubscriptions: subscription },
        }).exec();
    }

    async removePushSubscription(userId: string, endpoint: string): Promise<void> {
        await this.userModel.findByIdAndUpdate(userId, {
            $pull: { pushSubscriptions: { endpoint } },
        }).exec();
    }
}
