class CategorieModel {
  CategorieModel({required this.imagePath, required this.categorieName});

  String imagePath, categorieName;
}

List<CategorieModel> getCategories() {
  List<CategorieModel> myCategories = [];
  CategorieModel categorieModel;

  categorieModel = CategorieModel(
      imagePath: "assets/images/categorie_images/business.jpg",
      categorieName: "Business");
  myCategories.add(categorieModel);

  categorieModel = CategorieModel(
      imagePath: "assets/images/categorie_images/entertainment.jpg",
      categorieName: "Entertainment");
  myCategories.add(categorieModel);

  categorieModel = CategorieModel(
      imagePath: "assets/images/categorie_images/general.jpg",
      categorieName: "General");
  myCategories.add(categorieModel);

  categorieModel = CategorieModel(
      imagePath: "assets/images/categorie_images/health.jpg",
      categorieName: "Health");
  myCategories.add(categorieModel);

  categorieModel = CategorieModel(
      imagePath: "assets/images/categorie_images/science.jpg",
      categorieName: "Science");
  myCategories.add(categorieModel);

  categorieModel = CategorieModel(
      imagePath: "assets/images/categorie_images/sports.jpg",
      categorieName: "Sports");
  myCategories.add(categorieModel);

  categorieModel = CategorieModel(
      imagePath: "assets/images/categorie_images/technology.jpg",
      categorieName: "Technology");
  myCategories.add(categorieModel);

  return myCategories;
}
