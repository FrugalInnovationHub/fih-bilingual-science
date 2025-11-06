# Manual Testing Guide for Signup with User Creation

## Testing Steps

1. **Open the app in browser**: http://localhost:8080

2. **Navigate to Signup**:
   - Click "Don't have Code? Create One" button on the login screen

3. **Test Signup Process**:
   - Enter a name (e.g., "Test User")
   - Enter a 3-digit PIN (e.g., "123")
   - Click "Sign Up!" button

4. **Verify Success**:
   - Should redirect to login screen
   - No error messages should appear

5. **Test Login with New PIN**:
   - Enter the same PIN you just created (e.g., "123")
   - Click "Let's Play"
   - Should successfully log in and go to home screen

## What Should Happen in Firebase

When you sign up, the following should be created in Firebase:

### In `pins` collection:
- A new document with auto-generated ID
- Fields: `pin`, `created_at`, `name`

### In `users` collection:
- A new document with PIN as the key (e.g., document ID = "123")
- Fields: `pin`, `name`, `created_at`, `MathMingle: 0`, `MathEquations: 0`, `MathOperators: 0`, `TotalBestScore: 0`

## Expected Behavior

✅ **Success Indicators**:
- Signup completes without errors
- User can immediately log in with the new PIN
- User record is created in Firebase with proper structure
- Game scores are initialized to 0

❌ **Error Indicators**:
- Signup fails with error message
- User cannot log in after signup
- Firebase records are not created properly

## Testing Different Scenarios

1. **Valid Signup**: Name + 3-digit PIN
2. **Invalid PIN**: Try with 2 digits or 4 digits
3. **Duplicate PIN**: Try to create a PIN that already exists
4. **Empty Name**: Try with empty name field
5. **Empty PIN**: Try with empty PIN fields

## Firebase Console Verification

To verify the data was created correctly:
1. Go to Firebase Console
2. Navigate to Firestore Database
3. Check both `pins` and `users` collections
4. Verify the user document has the correct structure and initial values

