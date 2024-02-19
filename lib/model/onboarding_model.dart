// ignore_for_file: public_member_api_docs, sort_constructors_first
class OnboardingModel {
  final String image_path;
  final String title;
  final String discription;
  OnboardingModel({
    required this.image_path,
    required this.title,
    required this.discription,
  });
}

List<OnboardingModel> onboardingContent = [
  OnboardingModel(
      image_path: 'assets/images/first_onboarding_page_image.png',
      title: 'Mesajlaşma',
      discription:
          'Mobil uygulama geliştirme süreçleri, kullanıcı arayüzü tasarımından başlayarak'),
  OnboardingModel(
      image_path: 'assets/images/second_onboarding_page_image.png',
      title: 'Mesajlaşma',
      discription:
          'Mobil uygulama geliştirme süreçleri, kullanıcı arayüzü tasarımından başlayarak'),
  OnboardingModel(
      image_path: 'assets/images/third_onboarding_page_image.png',
      title: 'Mesajlaşma',
      discription:
          'Mobil uygulama geliştirme süreçleri, kullanıcı arayüzü tasarımından başlayarak'),
];
