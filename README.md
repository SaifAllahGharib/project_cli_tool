# Project CLI Tool

A Dart CLI for generating Flutter features, Cubits, Blocs, Repositories, and Datasources with a
clean and consistent folder structure.

## ⚡ Features

- Generate **Feature folder structure**: `data`, `domain`, `presentation`
- Generate **Cubit** + **State** classes
- Generate **Bloc** + **Event** + **State** classes
- Generate **Repository** classes
- Generate **Remote DataSource** classes (Retrofit-ready)
- Supports **custom class names**
- Fully **configurable via flags**
- Works on **Linux, macOS, and Windows**

## 📦 Installation

### 1. Clone the repository

`git clone https://github.com/SaifAllahGharib/project_cli_tool.git`

`cd project_cli_tool`

### 2. Activate globally from the repository

This will make `project_cli_tool` available anywhere on your system:

`dart pub global activate --source path .`

> No need to modify PATH manually if Dart is installed correctly; the CLI will be globally
> available.

## 🚀 Usage

`project_tools <feature_name> [flags] [--name <CustomClassName>]`

### Flags

| Flag | Description                             |
|------|-----------------------------------------|
| `-f` | Generate empty feature folder structure |
| `-c` | Generate Cubit + State                  |
| `-b` | Generate Bloc + Event + State           |
| `-r` | Generate Repository                     |
| `-d` | Generate Remote DataSource              |

### Options

| Option                     | Description                                     |
|----------------------------|-------------------------------------------------|
| `--name <CustomClassName>` | Specify a custom class name for generated files |

## 📁 Folder Structure

When generating a feature (`-f`), the CLI creates the following folders:

lib/features/<feature_name>/  
data/  
data_sources/  
models/  
repository/  
domain/  
entities/  
presentation/  
cubit/  
screens/  
widgets/

## 📌 Examples (using `login` feature)

### 1️⃣ Generate full feature folders

`project_tools login -f`

Creates all folders under lib/features/login/ without any files.

### 2️⃣ Generate Cubit with custom class name

`project_tools login -c --name login`

Creates:

lib/features/login/presentation/cubit/  
login_cubit.dart  
login_state.dart

Class names:

class LoginCubit extends Cubit<LoginState> { ... }  
class LoginState extends Equatable { ... }

### 3️⃣ Generate Bloc with custom class name

`project_tools login -b --name login`

Creates:

lib/features/login/presentation/bloc/  
login_bloc.dart  
login_bloc_event.dart  
login_state.dart

### 4️⃣ Generate Repository and Remote DataSource

`project_tools login -r -d --name login`

Creates:

lib/features/login/data/repository/login_repository.dart  
lib/features/login/data/data_sources/login_remote_datasource.dart

### 5️⃣ Combine multiple flags

`project_tools login -f -c -b -r -d --name login`

Generates full folder structure + Cubit + Bloc + Repository + Datasource in one command.
