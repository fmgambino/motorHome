
		import 'package:motor_home/features/home/domain/repositories/home.repository.dart';
		
		class UpdateHomeUsecase {
			const UpdateHomeUsecase(this.repository);
	  
			final HomeRepository repository;
	  
			Future<T> call<T>() async => repository.update();
		}