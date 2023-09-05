package hu.zero.app;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;

import java.time.Instant;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadPoolExecutor;

@SpringBootApplication
@EnableScheduling
public class App {
	static final ConcurrentHashMap<String, Integer> storage = new ConcurrentHashMap<>();

	public static void main(String[] args) {
		SpringApplication.run(App.class, args);
	}

	@Scheduled(fixedRate = 10000)
	public void runCron() {
		ThreadPoolExecutor executor =
				(ThreadPoolExecutor) Executors.newCachedThreadPool();

		for (int i = 0; i < 10; i++) {
			for (int j = 0; j < 5; j++) {
				String key = i + "-" + j;
				executor.submit(() -> {
					Integer counter = storage.getOrDefault(key, 0);
					System.out.println(counter);
					counter++;
					storage.put(key, counter);
					System.out.println(Instant.now());

					try {
						Thread.sleep(2000);
					} catch (InterruptedException e) {
						throw new RuntimeException(e);
					}
				});
			}
		}

		System.out.println("RUNNiNG");
	}
}







