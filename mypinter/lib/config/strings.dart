class AppStrings {
  // Helper method to get strings based on language
  static String get(String key, String language) {
    final isZh = language == 'zh_TW';
    
    switch (key) {
      // Common
      case 'appName': return 'Pinter';
      
      // Navigation
      case 'forum': return isZh ? '論壇' : 'Forum';
      case 'chat': return isZh ? '聊天' : 'Chat';
      case 'pairing': return isZh ? '配對' : 'Pairing';
      case 'map': return isZh ? '地圖' : 'Map';
      case 'home': return isZh ? '首頁' : 'Home';
      case 'account': return isZh ? '帳號' : 'Account';
      case 'settings': return isZh ? '設定' : 'Settings';
      
      // Forum Topics
      case 'generalDiscussion': return isZh ? '一般討論' : 'General Discussion';
      case 'healthNutrition': return isZh ? '健康與營養' : 'Health & Nutrition';
      case 'trainingBehavior': return isZh ? '訓練與行為' : 'Training & Behavior';
      case 'adoptionRescue': return isZh ? '領養與救援' : 'Adoption & Rescue';
      case 'eventsMeetups': return isZh ? '活動與聚會' : 'Events & Meetups';
      
      // Chat
      case 'newGroup': return isZh ? '新增群組' : 'New Group';
      case 'newChat': return isZh ? '新增聊天' : 'New Chat';
      case 'typeMessage': return isZh ? '輸入訊息...' : 'Type a message...';
      case 'online': return isZh ? '線上' : 'Online';
      case 'offline': return isZh ? '離線' : 'Offline';
      case 'members': return isZh ? '位成員' : 'members';
      case 'unknown': return isZh ? '未知' : 'Unknown';
      case 'now': return isZh ? '現在' : 'Now';
      case 'yesterday': return isZh ? '昨天' : 'Yesterday';
      
      // Group Chat
      case 'selectContacts': return isZh ? '選擇聯絡人' : 'Select Contacts';
      case 'searchContacts': return isZh ? '搜尋聯絡人...' : 'Search contacts...';
      case 'selected': return isZh ? '已選擇' : 'selected';
      case 'next': return isZh ? '下一步' : 'Next';
      case 'groupName': return isZh ? '群組名稱' : 'Group name';
      case 'participants': return isZh ? '成員' : 'Participants';
      case 'createGroup': return isZh ? '建立群組' : 'Create Group';
      case 'pleaseEnterGroupName': return isZh ? '請輸入群組名稱' : 'Please enter a group name';
      
      // Auth
      case 'email': return isZh ? '電子郵件' : 'Email';
      case 'password': return isZh ? '密碼' : 'Password';
      case 'confirmPassword': return isZh ? '確認密碼' : 'Confirm Password';
      case 'login': return isZh ? '登入' : 'Login';
      case 'register': return isZh ? '註冊' : 'Register';
      case 'createAccount': return isZh ? '建立你的帳號' : 'Create your account';
      case 'alreadyHaveAccount': return isZh ? '已經有帳號了？' : 'Already have an account?';
      case 'dontHaveAccount': return isZh ? '還沒有帳號？' : "Don't have an account?";
      case 'registerNow': return isZh ? '立即註冊' : 'Register now';
      case 'orSignInWith': return isZh ? '或使用以下方式登入' : 'Or sign in with';
      case 'orSignUpWith': return isZh ? '或使用以下方式註冊' : 'Or sign up with';
      case 'forgotPassword': return isZh ? '忘記密碼？' : 'Forgot Password?';
      
      // Time
      case 'am': return isZh ? '上午' : 'AM';
      case 'pm': return isZh ? '下午' : 'PM';
      
      // Settings
      case 'saccount': return isZh ? '帳號' : 'Account';
      case 'preferences': return isZh ? '偏好設定' : 'Preferences';
      case 'support': return isZh ? '支援' : 'Support';
      case 'editProfile': return isZh ? '編輯個人資料' : 'Edit Profile';
      case 'changePassword': return isZh ? '更改密碼' : 'Change Password';
      case 'notifications': return isZh ? '通知' : 'Notifications';
      case 'language': return isZh ? '語言' : 'Language';
      case 'darkMode': return isZh ? '深色模式' : 'Dark Mode';
      case 'followSystem': return isZh ? '跟隨系統' : 'Follow System';
      case 'helpSupport': return isZh ? '幫助與支援' : 'Help & Support';
      case 'aboutUs': return isZh ? '關於我們' : 'About Us';
      case 'logout': return isZh ? '登出' : 'Logout';
      
      // Language
      case 'selectLanguage': return isZh ? '選擇語言' : 'Select Language';
      case 'traditionalChinese': return isZh ? '繁體中文' : 'Traditional Chinese';
      case 'english': return 'English';
      case 'languageSetToChinese': return isZh ? '已設定為繁體中文' : 'Language set to Traditional Chinese';
      case 'languageSetToEnglish': return 'Language set to English';
      
      // Theme
      case 'selectTheme': return isZh ? '選擇主題' : 'Select Theme';
      case 'light': return isZh ? '淺色' : 'Light';
      case 'dark': return isZh ? '深色' : 'Dark';
      
      // Error Messages
      case 'loadingFailed': return isZh ? '載入跟你的人生一樣失敗 :P' : 'Loading failed like your life :P';
      case 'retry': return isZh ? '再試一次' : 'Retry';
      
      default: return key;
    }
  }
}
