class StringUtils {
  static String formatAuthorName(String? authorName, {bool fullName = false}) {
    if (authorName == null || authorName.isEmpty || authorName == 'null') {
      return 'Unknown';
    }

    if (fullName) return authorName;

    // If total length is small enough, return as is
    if (authorName.length <= 12) return authorName;

    // Split the name into parts
    List<String> nameParts = authorName.split(' ');
    
    if (nameParts.length == 1) {
      // If it's a single long word, return first initial and last 6 chars
      return '${nameParts[0].substring(0, 1)}. ${nameParts[0].substring(nameParts[0].length - 6)}';
    }

    // Process multi-word names
    String result = '';
    
    // Add first name initial
    result += '${nameParts[0][0]}.';
    
    // Process middle names if they exist
    for (int i = 1; i < nameParts.length - 1; i++) {
      if (nameParts[i].length > 0) {
        result += ' ${nameParts[i][0]}.';
      }
    }
    
    // Process last name
    String lastName = nameParts.last;
    if (lastName.length > 7) {
      // If last name is too long, use first initial and last 6 chars
      result += ' ${lastName[0]}.';
    } else {
      // Otherwise use full last name
      result += ' $lastName';
    }
    
    return result.trim();
  }
}
