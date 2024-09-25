import datetime

with open("hello.txt", "a") as f:
    f.write(f"Hello from {datetime.datetime.now(datetime.timezone.utc)}\n")

# Close the file when done writing
f.close()
