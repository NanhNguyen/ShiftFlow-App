import { Injectable, UnauthorizedException, ConflictException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { UsersService } from '../users/users.service';
import * as bcrypt from 'bcrypt';
import { User } from '../users/schemas/user.schema';

@Injectable()
export class AuthService {
    constructor(
        private usersService: UsersService,
        private jwtService: JwtService,
    ) { }

    async register(userData: Partial<User>) {
        const existingUser = await this.usersService.findByEmail(userData.email!);
        if (existingUser) {
            throw new ConflictException('Email already exists');
        }
        const user = await this.usersService.create(userData);
        return this.login(user);
    }

    async login(user: any) {
        const payload = { email: user.email, sub: user._id, role: user.role };

        const access_token = this.jwtService.sign(payload, { expiresIn: '15m' });
        const refresh_token = this.jwtService.sign(payload, { expiresIn: '7d' });

        await this.usersService.update(user._id, { refreshToken: refresh_token });

        return {
            access_token,
            refresh_token,
            user: {
                id: user._id,
                email: user.email,
                name: user.name,
                role: user.role,
            },
        };
    }

    async refresh(oldRefreshToken: string) {
        try {
            const payload = this.jwtService.verify(oldRefreshToken);
            const user = await this.usersService.findById(payload.sub);

            if (!user || user.refreshToken !== oldRefreshToken) {
                throw new UnauthorizedException('Sai refresh token');
            }

            const newPayload = { email: user.email, sub: user._id, role: user.role };
            const access_token = this.jwtService.sign(newPayload, { expiresIn: '15m' });

            return { access_token };
        } catch (e) {
            throw new UnauthorizedException('Phiên làm việc đã hết hạn, vui lòng đăng nhập lại');
        }
    }

    async validateUser(email: string, pass: string): Promise<any> {
        console.log(`Attempting login for email: ${email}`);
        const user = await this.usersService.findByEmail(email);

        if (!user) {
            console.log(`User not found for email: ${email}`);
            return null;
        }

        console.log(`User found: ${user.name}. Comparing passwords...`);
        const isMatch = await bcrypt.compare(pass, user.password_hash);

        if (isMatch) {
            console.log('Password match successful!');
            const mappedRole = user.role; // This is the role mapped from role_id
            const { password_hash, ...result } = user.toObject();
            result.role = mappedRole; // Ensure the mapped role overrides the DB default
            console.log(`User role resolved: ${result.role}`);
            return result;
        } else {
            console.log('Password mismatch!');
            return null;
        }
    }
}
