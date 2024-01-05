
		import 'package:motor_home/features/home/domain/repositories/home.repository.dart';
		
		class CreateHomeUsecase {
			const CreateHomeUsecase(this.repository);
	  
			final HomeRepository repository;
	  
			Future<T> call<T>() async => repository.create();
		}