from playwright.sync_api import sync_playwright
import threading
import time
import statistics

def run_test():
    start_time = time.time()
    with sync_playwright() as p:
        browser = p.chromium.connect_over_cdp("ws://209.38.189.247:9222")
        context = browser.new_context()
        page = context.new_page()
        page.goto("https://wikipedia.com/")
        links = page.evaluate("""() => {
            return Array.from(document.querySelectorAll('a')).map(row => {
                return row.getAttribute('href');
            });
        }""")
        print(f"Found {len(links)} links")
        page.close()
        context.close()
        browser.close()
    
    execution_time = time.time() - start_time
    print(f"Run completed in {execution_time:.2f} seconds")
    return execution_time

execution_times = []
threads = []
for i in range(25):
    thread = threading.Thread(target=lambda: execution_times.append(run_test()))
    threads.append(thread)
    thread.start()
    print(f"Started thread {i+1}")

for thread in threads:
    thread.join()

print("\nPerformance Statistics:")
print(f"Min: {min(execution_times):.2f} seconds")
print(f"Max: {max(execution_times):.2f} seconds")
print(f"Avg: {statistics.mean(execution_times):.2f} seconds")
print(f"Median: {statistics.median(execution_times):.2f} seconds")
