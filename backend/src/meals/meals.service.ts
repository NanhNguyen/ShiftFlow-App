import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { MealRegistration } from './schemas/meal-registration.schema';

@Injectable()
export class MealsService {
    constructor(
        @InjectModel(MealRegistration.name)
        private mealModel: Model<MealRegistration>,
    ) { }

    async create(userId: string, data: any): Promise<MealRegistration> {
        // Chuẩn hóa ngày về 00:00:00 để dễ so sánh
        if (data.startDate) {
            const start = new Date(data.startDate);
            start.setHours(0, 0, 0, 0);
            data.startDate = start;
        }
        if (data.endDate) {
            const end = new Date(data.endDate);
            end.setHours(23, 59, 59, 999);
            data.endDate = end;
        }
        const meal = new this.mealModel({ userId, ...data });
        return meal.save();
    }

    async findMyMeals(userId: string): Promise<MealRegistration[]> {
        return this.mealModel
            .find({ userId })
            .sort({ startDate: -1 })
            .exec();
    }

    // HR/Manager: xem cơm của toàn bộ nhân viên
    async findAll(): Promise<MealRegistration[]> {
        return this.mealModel
            .find()
            .populate('userId', 'name email role')
            .sort({ startDate: -1 })
            .exec();
    }

    async remove(id: string, userId: string, userRole: string): Promise<void> {
        const meal = await this.mealModel.findById(id);
        if (!meal) throw new NotFoundException('Không tìm thấy đăng ký cơm');

        // HR có quyền xóa bất kỳ ai, người khác chỉ được xóa của mình
        if (userRole !== 'HR' && meal.userId.toString() !== userId) {
            throw new ForbiddenException('Bạn không có quyền xóa đăng ký này');
        }
        await this.mealModel.findByIdAndDelete(id);
    }


    async findOverview(date: Date): Promise<any[]> {
        const queryDate = new Date(date);
        queryDate.setHours(0, 0, 0, 0);

        const endOfDay = new Date(date);
        endOfDay.setHours(23, 59, 59, 999);

        // Map JS getDay() (0-6, 0=Sun) to MealWeekday
        const dayMap = [
            null, // Sunday
            'MONDAY',
            'TUESDAY',
            'WEDNESDAY',
            'THURSDAY',
            'FRIDAY',
            null, // Saturday
        ];
        const dayName = dayMap[queryDate.getDay()];

        // Tìm tất cả các bản ghi có thể chứa ngày này
        // Điều kiện: startDate <= ngày truy vấn (00:00:00) 
        // VÀ (không có endDate HOẶC endDate >= ngày truy vấn)
        const allRegistrations = await this.mealModel
            .find({
                startDate: { $lte: endOfDay },
                $or: [
                    { endDate: { $exists: false } },
                    { endDate: null },
                    { endDate: { $gte: queryDate } },
                ],
            })
            .populate('userId', 'name email role')
            .exec();

        // Lọc lại bằng logic: lặp lại theo thứ HOẶC nằm trong khoảng thời gian (nếu không lặp lại)
        return allRegistrations.filter((reg) => {
            if (reg.isRecurring) {
                return dayName && reg.weekdays.includes(dayName as any);
            } else {
                // Kiểm tra xem queryDate có nằm trong [startDate, endDate] không
                const start = new Date(reg.startDate);
                start.setHours(0, 0, 0, 0);
                const end = reg.endDate ? new Date(reg.endDate) : start;
                end.setHours(23, 59, 59, 999);

                return queryDate >= start && queryDate <= end;
            }
        });
    }


}

