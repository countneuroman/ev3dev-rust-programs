APP_NAME ?= $(error Variable APP_NAME is empty . Example: make APP_NAME="HelloWorld")

APP_DIR := src/$(APP_NAME)

ifeq ($(OS),Windows_NT)
    ARTIFACT := $(shell powershell -command "(Get-Content $(APP_DIR)/Cargo.toml | Select-String '^name =').ToString().Split('\"')[1]")
	SSH_PATH := C:/Windows/Sysnative/OpenSSH/ssh.exe
	SCP_PATH := C:/Windows/Sysnative/OpenSSH/scp.exe
else
    ARTIFACT := $(shell cargo pkgid --manifest-path $(APP_DIR)/Cargo.toml | rev | cut -d "/" -f1 | rev | cut -d "#" -f1)
	SSH_PATH := ssh
	SCP_PATH := scp
endif

# Replace this with your ssh configuration for the robot like `robot@192.168.2.3`
TARGET := robot@ev3dev

all: build deploy run

build:
	docker run --rm -v $(CURDIR):/build -w /build ev3-rust:latest \
		cargo build --release --target armv5te-unknown-linux-musleabi --manifest-path $(APP_DIR)/Cargo.toml

deploy:
	$(SCP_PATH) $(CURDIR)/target/armv5te-unknown-linux-musleabi/release/$(ARTIFACT) $(TARGET):.
	$(SSH_PATH) $(TARGET) chmod +x ./$(ARTIFACT)

run:
	$(SSH_PATH) $(TARGET) brickrun -r ./$(ARTIFACT)
