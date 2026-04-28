from apps.product.models import Product, Category
from apps.product.serializers import ProductSerializer, CategorySerializer
from rest_framework import viewsets


class ProductModelViewSet(viewsets.ModelViewSet):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer


class CategoryModelViewSet(viewsets.ModelViewSet):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer
