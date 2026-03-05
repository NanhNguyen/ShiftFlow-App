import { Controller, Post, Body, UseGuards, Request, Get, UnauthorizedException } from '@nestjs/common';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { AuthService } from './auth.service';
import { User } from '../users/schemas/user.schema';

@Controller('auth')
export class AuthController {
    constructor(private authService: AuthService) { }

    @Post('register')
    async register(@Body() userData: Partial<User>) {
        return this.authService.register(userData);
    }

    @Post('login')
    async login(@Body() body: any) {
        const user = await this.authService.validateUser(body.email, body.password);
        if (!user) {
            throw new UnauthorizedException('Sai tài khoản hoặc mật khẩu');
        }
        return this.authService.login(user);
    }

    @Post('refresh')
    async refresh(@Body('refresh_token') refreshToken: string) {
        return this.authService.refresh(refreshToken);
    }

    @UseGuards(JwtAuthGuard)
    @Get('profile')
    async getProfile(@Request() req) {
        const user = req.user;
        return {
            id: user._id,
            email: user.email,
            name: user.name,
            role: user.role,
        };
    }
}
