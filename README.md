# News App

A modern Flutter news application built with GetX state management and MVC architecture.

## Features

- Real-time news updates
- Current affairs section
- Interactive quiz system
- User profile management
- Custom date-based news search
- Voice search functionality
- News sharing capabilities
- Rating system
- Dark/Light theme support
- Offline storage support

## Technology Stack

### Framework
- Flutter SDK >=3.1.0
- GetX for state management
- MVC (Model-View-Controller) architecture

### Key Dependencies
- `get`: State management and routing
- `get_storage`: Local storage management
- `cached_network_image`: Efficient image loading and caching
- `http`: API communication
- `google_nav_bar`: Modern bottom navigation
- `flutter_rating_bar`: Rating functionality
- `speech_to_text`: Voice search feature
- `shimmer`: Loading animations
- `shared_preferences`: Local data persistence
- `image_picker`: Image selection functionality
- `permission_handler`: Device permissions management

## Project Structure
```
lib/
  ├── model/         # Data models
  ├── view/          # UI screens
  ├── controller/    # Business logic
  ├── utils/         # Helper functions
  └── services/      # API services
```

## Database Structure
```mermaid
erDiagram
    User {
        string id PK
        string name
        string email
        string profileImage
        string language
        datetime createdAt
    }
    
    Article {
        string id PK
        string title
        string description
        string url
        string urlToImage
        string publishedAt
        string content
        string author
        string category
    }
    
    Source {
        string id PK
        string name
    }
    
    CurrentAffairs {
        string id PK
        string title
        string description
        string date
    }
    
    Bookmark {
        string id PK
        string userId FK
        string articleId FK
        datetime createdAt
    }
    
    Category {
        string id PK
        string name
        string description
    }
    
    UserInterest {
        string userId FK
        string categoryId FK
        datetime createdAt
    }
    
    Quiz {
        string id PK
        string currentAffairsId FK
        string question
        string correctAnswer
        json options
    }
    
    UserQuizAttempt {
        string id PK
        string userId FK
        string quizId FK
        string selectedAnswer
        boolean isCorrect
        datetime attemptedAt
    }

    Article ||--|| Source : "has"
    User ||--o{ Bookmark : "creates"
    Article ||--o{ Bookmark : "included_in"
    User ||--o{ UserInterest : "has"
    Category ||--o{ UserInterest : "belongs_to"
    Article ||--o{ Category : "belongs_to"
    CurrentAffairs ||--o{ Quiz : "has"
    User ||--o{ UserQuizAttempt : "makes"
    Quiz ||--o{ UserQuizAttempt : "attempted_in"
```

## Getting Started

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Configure your API keys (check `.env.example` for required keys)
4. Run the app:
   ```bash
   flutter run
   ```

## Security Note
API keys and sensitive credentials should be stored in a secure environment file. Never commit sensitive credentials to version control.

## Design
- Material Design principles
- Modern UI/UX with smooth animations
- Responsive layout for various screen sizes
- Custom themes support

## Performance Features
- Efficient image caching
- Lazy loading
- Offline support
- Optimized state management

## Contributing
Feel free to submit issues and enhancement requests.
