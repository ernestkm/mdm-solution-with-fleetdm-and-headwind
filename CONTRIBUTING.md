# Contributing to Unified MDM Solution

Thank you for considering contributing to the Unified MDM Solution! This guide will help you understand how to contribute effectively to our project.

## Introduction

The Unified MDM Solution integrates multiple open-source MDM platforms (FleetDM, Headwind MDM, and MicroMDM) into a single, unified management interface. Our goal is to provide a comprehensive device management solution that supports various operating systems and device types through a containerized architecture.

We welcome contributions of all kinds including:

- Bug fixes and issue reporting
- Feature enhancements
- Documentation improvements
- User experience refinements
- Integration with additional MDM platforms
- Performance optimizations

## Code of Conduct

Our project is governed by our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to the project maintainers.

## Setting Up Your Development Environment

### Prerequisites

Before you begin, ensure you have installed:
- Docker Engine (20.10+)
- Docker Compose V2
- Git
- Node.js (16+) for frontend and API development
- Your preferred code editor (VSCode recommended)

### Local Development Setup

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```
   git clone https://github.com/YOUR-USERNAME/unified-mdm-solution.git
   cd unified-mdm-solution
   ```

3. Set up upstream remote:
   ```
   git remote add upstream https://github.com/original-owner/unified-mdm-solution.git
   ```

4. Create a development environment:
   ```
   cp unified-mdm/.env.example unified-mdm/.env
   # Edit .env with development configuration
   ```

5. Generate development SSL certificates:
   ```
   cd unified-mdm/config/nginx
   ./ssl-setup.sh localhost
   cd ../../
   ```

6. Start the services in development mode:
   ```
   ./start.sh dev
   ```

### Working on Components

#### Frontend (React)

1. Install dependencies:
   ```
   cd unified-mdm/frontend
   npm install
   ```

2. Start development server:
   ```
   npm start
   ```

3. Access the frontend at `http://localhost:3000`

#### API Gateway

1. Install dependencies:
   ```
   cd unified-mdm/api
   npm install
   ```

2. Start development server:
   ```
   npm run dev
   ```

3. API will be available at `http://localhost:4000`

## How to Submit Changes

### Branch Naming Convention

- Use `feature/` prefix for new features
- Use `fix/` prefix for bug fixes
- Use `docs/` prefix for documentation changes
- Use `refactor/` prefix for code refactoring

Example: `feature/android-bulk-enrollment`

### Development Workflow

1. Create a new branch for your changes:
   ```
   git checkout -b feature/your-feature-name
   ```

2. Make your changes and commit them with clear, descriptive messages:
   ```
   git commit -m "Add feature: detailed description of changes"
   ```

3. Keep your branch updated with upstream:
   ```
   git fetch upstream
   git rebase upstream/main
   ```

4. Push your changes to your fork:
   ```
   git push origin feature/your-feature-name
   ```

5. Create a Pull Request (PR) from your fork to the main repository

### Pull Request Process

1. Fill out the PR template completely
2. Link any related issues using keywords (Fixes #123, Relates to #456)
3. Ensure all CI checks pass
4. Request review from maintainers
5. Address any feedback from code reviews
6. Once approved, a maintainer will merge your PR

## Coding Conventions and Standards

### General Guidelines

- Write clean, readable, and maintainable code
- Follow the principle of "Single Responsibility"
- Add comments for complex logic, but prefer self-explanatory code
- Write unit tests for new functionality

### JavaScript/TypeScript

- Follow the ESLint configuration provided in the project
- Use TypeScript for type safety whenever possible
- Use async/await instead of promise chains
- Follow the React Hooks pattern for React components

### Docker

- Keep container images as small as possible
- Use multi-stage builds when appropriate
- Provide clear environment variable documentation
- Ensure proper container healthchecks are implemented

### Git Commit Messages

- Use the imperative mood ("Add feature" not "Added feature")
- Keep the first line under 50 characters
- Provide detailed explanations in the commit body when needed
- Reference issue numbers when applicable

## How to Report Bugs

1. Check if the bug is already reported in the Issues section
2. Use the Bug Report template when creating a new issue
3. Provide detailed steps to reproduce the issue
4. Include relevant information about your environment
5. Add screenshots or logs if applicable
6. Label the issue appropriately

## How to Suggest Improvements

1. Check if the improvement is already suggested in the Issues section
2. Use the Feature Request template when creating a new issue
3. Clearly describe the problem your improvement would solve
4. Suggest a solution if you have one in mind
5. Explain why this improvement would benefit the project
6. Label the issue appropriately

## Documentation

- Keep README.md and other documentation up-to-date
- Document new features in both code comments and user documentation
- Use clear, concise language and avoid jargon
- Include examples and screenshots where appropriate

## Review Process

- All code changes require at least one review from a maintainer
- Large changes may require multiple reviews
- Code will be tested both automatically via CI and manually
- Documentation changes also require review

## Community

- Join our community discussions on [GitHub Discussions](https://github.com/organization/unified-mdm-solution/discussions)
- Ask questions on appropriate channels
- Help others with issues you've already solved
- Share ideas and feedback constructively

Thank you for contributing to the Unified MDM Solution!
