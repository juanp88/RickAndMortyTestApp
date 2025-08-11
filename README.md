# Rick and Morty Test Application

A Flutter application that provides a comprehensive interface for exploring Rick and Morty characters, with advanced features including character upload functionality powered by AWS services.

## Overview

This application serves as a test platform for the Rick and Morty API, featuring:
- Browse and search characters from the Rick and Morty universe
- Detailed character information display
- Character upload functionality with AWS integration
- Clean architecture following Flutter best practices
- Internationalization support

## Prerequisites

Before running this application, ensure you have:
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- AWS CLI configured with appropriate permissions
- Node.js and npm (for backend deployment)

## Project Structure

The project follows a clean architecture pattern:

```
lib/
├── Core/           # Core functionality and utilities
├── Data/           # Data layer (models, repositories, remote)
├── Domain/         # Business logic layer
├── Presentation/   # UI layer (screens, widgets, viewmodels)
└── l10n/          # Localization files
```

## AWS Backend Setup

**Important:** The character upload feature requires the backend Lambda functions to be properly configured in AWS. Follow these steps:

### 1. Backend Repository Setup

1. Clone the backend repository:
   ```bash
   git clone [backend-repo-url] D:\Flutter\RickAndMortyTestBackend
   cd D:\Flutter\RickAndMortyTestBackend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

### 2. AWS Infrastructure Deployment

1. **Create S3 Bucket** (for character image storage):
   ```bash
   aws s3 mb s3://rickandmorty-character-images-[unique-id]
   ```

2. **Deploy Lambda Functions**:
   ```bash
   # Deploy the upload handler
   aws lambda create-function \
     --function-name rickandmorty-upload-handler \
     --runtime nodejs18.x \
     --role arn:aws:iam::[your-account]:role/lambda-execution-role \
     --handler index.handler \
     --zip-file fileb://function.zip \
     --environment Variables={BUCKET_NAME=rickandmorty-character-images-[unique-id]}
   ```

3. **Configure API Gateway**:
   ```bash
   # Create API Gateway
   aws apigateway create-rest-api --name 'RickAndMortyAPI'
   
   # Create resources and methods for upload endpoint
   # Note: Detailed API Gateway setup instructions are in the backend README
   ```

4. **Update CORS Configuration**:
   Ensure your API Gateway has proper CORS headers configured for your Flutter app domain.

### 3. Environment Configuration

#### Create local_properties.env

Create a `local_properties.env` file in the project root with your AWS endpoints:

```bash
# Create the file
echo "BASE_URL=https://your-api-gateway-url.execute-api.region.amazonaws.com/stage" > local_properties.env
```

**File: `local_properties.env`**
```
BASE_URL=https://your-api-gateway-url.execute-api.region.amazonaws.com/stage
```

Replace `your-api-gateway-url`, `region`, and `stage` with your actual AWS API Gateway values.

#### Load Environment Variables

The application loads environment variables from `local_properties.env` at runtime. Ensure this file exists before running the app.

## Installation & Setup

1. **Clone the repository**:
   ```bash
   git clone [your-repo-url]
   cd RickAndMortyTest
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Generate localization files**:
   ```bash
   flutter gen-l10n
   ```

4. **Create local_properties.env** (see AWS Setup section above)

5. **Run the application**:
   ```bash
   # For development
   flutter run
   
   # For specific platform
   flutter run -d android
   flutter run -d ios
   flutter run -d web
   ```

## Features

### Character Browser
- Browse all Rick and Morty characters
- Search functionality
- Filter by status, species, and gender
- Infinite scroll pagination

### Character Details
- Detailed character information
- Episode appearances
- Origin and location data

### Character Upload (AWS Integration)
- Upload custom character images
- Store metadata in AWS
- Retrieve uploaded characters
- **Note:** This feature requires the AWS backend to be properly configured

## Testing

Run the test suite:
```bash
flutter test
```

## Troubleshooting

### Common Issues

1. **Upload feature not working**: Ensure AWS backend is properly configured and `local_properties.env` contains the correct API endpoint.

2. **Build failures**: Run `flutter clean` and `flutter pub get` to refresh dependencies.

3. **Missing environment variables**: Verify `local_properties.env` exists and contains valid `BASE_URL`.

### AWS Configuration Issues

If you encounter AWS-related errors:
1. Verify AWS CLI is configured: `aws configure list`
2. Check Lambda function logs in AWS CloudWatch
3. Ensure API Gateway has proper CORS configuration
4. Verify S3 bucket permissions for image uploads

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is for testing purposes. Please refer to the original API terms of service for the Rick and Morty API.
