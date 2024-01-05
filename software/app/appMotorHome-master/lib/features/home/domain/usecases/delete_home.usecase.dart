
		import 'package:motor_home/features/home/domain/repositories/home.repository.dart';
		
		class DeleteHomeUsecase {
			const DeleteHomeUsecase(this.repository);
	  
			final HomeRepository repository;
	  
			Future<T> call<T>() async => repository.delete();
		}