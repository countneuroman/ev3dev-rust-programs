APP_NAME ?= $(error Variable APP_NAME is empty . Example: make APP_NAME="HelloWorld")

APP_DIR := src/$(APP_NAME)

ifeq ($(OS),Windows_NT)
    # Код для Windows (если нет Git Bash/Cygwin)
    # Простое решение: парсим имя через PowerShell
    ARTIFACT := $(shell powershell -command "(Get-Content $(APP_DIR)/Cargo.toml | Select-String '^name =').ToString().Split('\"')[1]")
else
    # Код для Linux / macOS / Docker-окружения
    ARTIFACT := $(shell cargo pkgid --manifest-path $(APP_DIR)/Cargo.toml | rev | cut -d "/" -f1 | rev | cut -d "#" -f1)
endif

# Replace this with your ssh configuration for the robot like `robot@192.168.2.3`
TARGET := robot@ev3dev

all: build

build:
	docker run --rm -v $(CURDIR):/build -w /build ev3-rust:latest \
		cargo build --release --target armv5te-unknown-linux-musleabi --manifest-path $(APP_DIR)/Cargo.toml

deploy:
	scp $(CURDIR)/target/armv5te-unknown-linux-musleabi/release/$(ARTIFACT) $(TARGET):.

run:
	ssh $(TARGET) brickrun -r ./$(ARTIFACT)
