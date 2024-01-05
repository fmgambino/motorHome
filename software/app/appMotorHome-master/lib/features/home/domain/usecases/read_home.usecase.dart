
		import 'package:motor_home/features/home/domain/repositories/home.repository.dart';
		
		class ReadHomeUsecase {
			const ReadHomeUsecase(this.repository);
	  
			final HomeRepository repository;
	  
			Future<T> call<T>() async => repository.read();
		}