# Photos-Viewer
An iOS application to create collections of photos for each user using Swift and Firebase

## Description
Login and Sign Up - The user's display name,email and password is stored in Firebase on sign up.

Users are able to retrieve the list of photos stored in Firebase Storage in UI CollectionView. Each user can view only their stored photos after logging in.
Clicking on the add button can enable the user to pick a photo from photo library on the device. This is done using UIImagePickerController which is resrtricted to photos only.
Upon selecting photos,this photo should be sent Firebase and UICollectionView should be refreshed to display the new photo.
Clicking on any photos in UICollectionView should navigate to detailed photo in another ViewController.It also allows the user to delete the photo selected from Firebase and navigate back to the list of photos.
All photo access is performes in child thread using SDWebImage library.

Demo is as following: (https://youtu.be/pd8Fw6WSNOU)
