# This files contains your custom actions which can be used to run
# custom Python code.
#
# See this guide on how to implement these action:
# https://rasa.com/docs/rasa-pro/concepts/custom-actions
import datetime

# This is a simple example for a custom action which utters "Hello World!"
import google.generativeai as genai
import datetime as dt
import mysql.connector
from mysql.connector import Error
import logging
from contextlib import contextmanager
import os

from typing import Any, Text, Dict, List

from rasa_sdk import Action, Tracker, FormValidationAction
from rasa_sdk.events import AllSlotsReset, EventType, Restarted, SlotSet, FollowupAction
from rasa_sdk.executor import CollectingDispatcher
from rasa_sdk.types import DomainDict


##############################################

# class ActionHelloWorld(Action):
#
#     def name(self) -> Text:
#         return "action_hello_world"
#
#     def run(self, dispatcher: CollectingDispatcher,
#             tracker: Tracker,
#             domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
#
#         dispatcher.utter_message(text="Hello World!")
#
#         return []

# Configure for Gemini
genai.configure(api_key="AIzaSyCjMOlYTEY0IvVsenAuxuRcG8M5oho5Trc")

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

DB_CONFIG = {
    'host': 'localhost',
    'database': 'storedb',
    'user': 'root',
    'password': '123456',
    'port': 3306
}

def format_generated_answer(text):
    prompt = f"Format the text by adding not too many emojis, keep it concise to the provided information, no need to provide any further information for me: {text}"

    result = ActionAskGemini.call_llm_model(prompt)

    return result.text

#####################################################################
def list_all_group_categories_name():
    query = """
        SELECT name
        FROM categories
        WHERE parent_id IS NULL
    """

    result = DatabaseManager.execute_query(query=query, params=None)
    group_categories_name = []

    for row in result:
        group_categories_name.append(row['name'])

    return group_categories_name

def list_categories_based_on_group_category_name(group_category_name):
    query = """
        SELECT name
        FROM categories
        WHERE parent_id = (SELECT id FROM categories WHERE name = %s)
    """

    result = DatabaseManager.execute_query(query=query, params=(group_category_name,))
    print(result)
    categories = []

    for row in result:
        categories.append(row['name'])

    return categories

def list_all_categories():
    query = """
        SELECT name
        FROM categories
        WHERE parent_id = (SELECT id 
                            FROM categories 
                            WHERE categories.name = "Kid's Fashion")
    """

    result = DatabaseManager.execute_query(query=query, params=None)
    categories = []

    for row in result:
        categories.append(row["name"])

    return categories

def list_all_brands():
    query = """
        SELECT DISTINCT brand
        FROM products
    """

    result = DatabaseManager.execute_query(query=query, params=None)
    brands = []

    for row in result:
        brands.append(row["brand"])

    return brands

def list_all_promotion_types():
    query = """
        SELECT DISTINCT type
        FROM promotions
    """

    result = DatabaseManager.execute_query(query=query, params=None)
    promotion_types = []

    for row in result:
        type = (str(row['type']).split('_'))[0].title()
        print(f"Promotion type: {type}")
        promotion_types.append(type)

    promotion_types[1] = "Delivery"

    return promotion_types

def list_all_product_types():
    query = """
            SELECT DISTINCT name
            FROM categories
            """

    all_group_categories_name = list_all_group_categories_name()
    all_categories = list_all_categories()
    result = DatabaseManager.execute_query(query=query, params=None)
    all_types = []

    for row in result:
        temp_type = row['name']
        if temp_type not in all_group_categories_name and temp_type not in all_categories:
            all_types.append(temp_type)

    return all_types

def list_all_topics():
    query = """
            SELECT name
            FROM tags
            """

    result = DatabaseManager.execute_query(query=query, params=None)
    all_topics = []

    for row in result:
        topic = row['name']
        all_topics.append(topic)

    return all_topics

def list_all_materials():
    query = """
            SELECT value
            FROM attributes
            WHERE type = "material"    
            """

    result = DatabaseManager.execute_query(query=query, params=None)
    all_materials = []

    for row in result:
        material = row['value']
        all_materials.append(material)

    return all_materials

def find_category_base_on_type(type):
    query = """
            SELECT name 
            FROM categories
            WHERE id = (SELECT max(parent_id) FROM categories where name = %s)
            """

    result = DatabaseManager.execute_query(query=query, params=(type,))

    for row in result:
        category = row['name']

    return category

#####################################################################

#####################################################################
def check_group_category_for_brand(group_category_name, brands):
    if group_category_name == "Kid's Fashion":
        brands.remove("Nike")

    return brands

def check_category_for_brand(category, brands):
    if category == "Accessories":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Gucci", "H&M"])
    elif category == "Dresses":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Adidas", "Bloom", "Gucci", "H&M", "Nike", "Puma", "Uniqlo", "Zara"])
    elif category == "Outerwear":
        pass
    elif category == "Pants":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Adidas", "Bloom", "Coolmate", "Everest", "Gucci", "H&M", "Nike", "Puma", "Routine", "Uniqlo","Zara"])
    elif category == "Shirts":
        pass
    elif category == "Shoes":
        pass
    elif category == "Swimwear":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Routine", "H&M", "Uniqlo"])

    return brands

def remove_brands_based_on_type(brands, brands_valid):
    for brand in brands:
        if brand not in brands_valid:
            try:
                brands.remove(brand)
            except ValueError:
                pass

    return brands

def check_type_for_brand(type, brands):
    if type == "Belt":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Gucci"])
    elif type == "Blouse":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Coolmate", "Zara", "Everest"])
    elif type == "Bomber Jacket":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Gucci"])
    elif type == "Boots":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Zara"])
    elif type == "Button-up Shirt":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Gucci", "Puma", "Routine", "Unqilo", "Zara"])
    elif type == "Cap":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["H&M"])
    elif type == "Cardigan":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Zara"])
    elif type == "Cargo Pants":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Everest", "Uniqlo", "Puma", "Zara"])
    elif type == "Coat":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Gucci"])
    elif type == "Corduroy Pants":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["H&M"])
    elif type == "Cover-up":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["H&M"])
    elif type == "Crop Top":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Coolmate", "Gucci", "Nike", "Puma", "Uniqlo"])
    elif type == "Culottes":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["H&M", "Coolmate", "Puma"])
    elif type == "Chinos":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Unqilo", "Bloom"])
    elif type == "Denim Jacket":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["H&M", "Zara"])
    elif type == "Denim Shirt":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Uniqlo", "Everest"])
    elif type == "Dress":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Uniqlo", "Bloom", "Gucci", "H&M", "Zara"])
    elif type == "Dress Pants":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Uniqlo", "Gucci", "Zara"])
    elif type == "Dress Shirt":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Zara"])
    elif type == "Flannel Shirt":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Zara", "Bloom", "Puma", "Uniqlo"])
    elif type == "Fleece Jacket":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Uniqlo"])
    elif type == "Flip-Flops":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["H&M", "Biti's"])
    elif type == "Henley Shirt":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Uniqlo", "Coolmate"])
    elif type == "Hoodie":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Adidas", "Gucci", "H&M", "Nike", "Uniqlo"])
    elif type == "Jacket":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Adidas", "Biti's", "Coolmate", "Everest", "Puma"])
    elif type == "Jeans":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Bloom", "Coolmate", "Everest", "H&M", "Zara"])
    elif type == "Joggers":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Coolmate", "Nike", "Puma", "Routine", "Uniqlo"])
    elif type == "Knitwear":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Zara"])
    elif type == "Kurta":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Routine"])
    elif type == "Leggings":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Bloom", "H&M", "Puma", "Routine"])
    elif type == "Loafers":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Zara"])
    elif type == "Maxi Dress":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Zara"])
    elif type == "Midi Dress":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Gucci"])
    elif type == "Overalls":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Routine"])
    elif type == "Overshirt":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["H&M", "Puma", "Everest"])
    elif type == "Parka":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Zara"])
    elif type == "Polo Shirt":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Adidas", "Biti's", "Bloom", "Coolmate", "Gucci", "H&M", "Nike", "Puma", "Routine", "Uniqlo", "Zara"])
    elif type == "Puffer Jacket":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Uniqlo"])
    elif type == "Raincoat":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Uniqlo", "Zara"])
    elif type == "Rash Guard":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Uniqlo", "Routine"])
    elif type == "Running Shoes":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Adidas"])
    elif type == "Sandals":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Biti's", "Bloom", "Coolmate", "Everest", "Gucci", "Routine"])
    elif type == "Scarf":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Gucci"])
    elif type == "Shorts":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Adidas", "Coolmate", "Gucci", "H&M", "Nike", "Puma", "Routine"])
    elif type == "Skirt":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Adidas", "Gucci", "Nike", "Puma", "Uniqlo"])
    elif type == "Slim-Fit Trousers":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["H&M", "Coolmate", "Everest"])
    elif type == "Sneakers":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Adidas", "Biti's", "Gucci", "H&M", "Nike", "Puma", "Routine", "Uniqlo", "Zara"])
    elif type == "Softshell Jacket":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Nike", "Uniqlo"])
    elif type == "Sports Jacket":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Nike"])
    elif type == "Sweater":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Uniqlo"])
    elif type == "Swim Shorts":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Uniqlo", "H&M"])
    elif type == "Swimsuit":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Coolmate", "Everest", "H&M"])
    elif type == "Tote Bag":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Gucci"])
    elif type == "T-shirt":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Biti's", "Bloom", "Coolmate", "Everest", "H&M", "Nike", "Routine", "Uniqlo", "Zara"])
    elif type == "Tunic":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Bloom", "Puma", "Zara"])
    elif type == "Track Pants":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Coolmate", "Nike"])
    elif type == "Trench Coat":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Zara"])
    elif type == "Utility Coat":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Routine"])
    elif type == "Vest":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Uniqlo"])
    elif type == "Water Shoes":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Biti's"])
    elif type == "Wide-Leg Pants":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Bloom", "Everest", "Gucci", "Puma", "Uniqlo"])
    elif type == "Windbreaker":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Uniqlo"])
    elif type == "Wool Coat":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["H&M"])

    return brands

def check_topic_for_brand(topic, brands):
    if "Athleisure" in topic and "Lifestyle" in topic:
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Adidas", "Biti's", "Bloom", "Coolmate", "Everest", "H&M", "Nike", "Uniqlo", "Zara"])
    elif "Athleisure" in topic and "Performance" in topic:
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Adidas", "Bloom", "Coolmate", "Everest", "Nike", "Puma", "Uniqlo"])
    elif "Lifestyle" in topic:
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Adidas", "Biti's", "Bloom", "Coolmate", "Everest", "H&M", "Nike", "Uniqlo", "Zara"])
    elif "Performance" in topic:
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Adidas", "Bloom", "Coolmate", "Everest", "Nike", "Puma", "Uniqlo"])
    elif "Athleisure" in topic:
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Adidas", "Biti's", "Bloom", "Coolmate", "Everest", "H&M", "Nike", "Uniqlo", "Puma", "Zara"])
    elif "Business Casual" in topic or "Modern Workwear" in topic:
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Routine", "Uniqlo", "Zara"])
    elif "Casual" in topic and "Everyday Essential" in topic:
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Adidas", "Biti's", "Bloom", "Coolmate", "Nike", "Puma", "Routine", "Uniqlo", "Zara"])
    elif "Casual" in topic and "Kids Everyday" in topic:
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Biti's", "H&M", "Everest", "Routine"])
    elif "Casual" in topic:
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["H&M", "Everest", "Adidas", "Biti's", "Bloom", "Coolmate", "Nike", "Puma", "Routine", "Uniqlo", "Zara"])
    elif "Everyday Essential" in topic:
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Adidas", "Biti's", "Bloom", "Coolmate", "Nike", "Puma", "Routine", "Uniqlo", "Zara"])
    elif "Kids Everyday" in topic:
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Biti's", "H&M", "Everest", "Routine"])
    elif "Cultural" in topic or "Festive Wear" in topic:
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Routine"])
    elif "Eco-Friendly" in topic or "Conscious Choice" in topic:
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Adidas", "Biti's", "Coolmate", "Nike", "Puma"])
    elif "Luxury" in topic or "Statement Piece" in topic:
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Gucci", "H&M", "Uniqlo", "Zara"])
    elif "Minimalist" in topic or "Clean Design" in topic:
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Biti's", "Bloom", "Coolmate", "Everest"])
    elif "Seasonal" in topic and "Summer & Swim" in topic:
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Adidas", "Biti's", "Bloom", "Coolmate", "Everest", "H&M", "Nike", "Puma", "Routine", "Uniqlo", "Zara"])
    elif "Seasonal" in topic and "Weather-Ready" in topic:
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Bloom", "Everest", "H&M", "Routine", "Uniqlo", "Zara"])
    elif "Seasonal" in topic :
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Adidas", "Biti's", "Bloom", "Coolmate", "Everest", "H&M", "Nike", "Puma", "Routine", "Uniqlo", "Zara"])
    elif "Summer & Swim" in topic:
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Adidas", "Biti's", "Bloom", "Coolmate", "Everest","H&M", "Nike", "Puma", "Routine", "Uniqlo", "Zara"])
    elif "Weather-Ready" in topic:
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Bloom", "Everest", "H&M", "Routine", "Uniqlo", "Zara"])
    elif "Streetwear" in topic or "Urban Essential" in topic:
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Adidas", "Biti's", "Bloom", "Coolmate", "Everest", "H&M", "Nike", "Puma", "Zara"])
    elif "Sustainable" in topic or "Core Essential" in topic:
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Adidas", "Bloom", "Coolmate", "Everest", "H&M", "Puma", "Uniqlo", "Zara"])
    elif "Vintage" in topic or "Retro" in topic or "Heritage Style":
        brands = remove_brands_based_on_type(brands=brands, brands_valid=["Bloom", "Coolmate", "Everest", "H&M", "Puma", "Uniqlo", "Zara"])

    return brands

def remove_group_category_name(group_category_names, valid_group_category_names):
    for group_category_name in group_category_names:
        if group_category_name not in valid_group_category_names:
            try:
                group_category_names.remove(group_category_name)
            except ValueError:
                pass

    return group_category_names

def check_category_for_group_category_name(category, group_category_names):
    if category == "Dresses":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Women's Fashion", "Kid's Fashion"])
    elif category == "Swimwear":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Kid's Fashion"])

    return group_category_names

def check_brand_for_group_category_name(brand, group_category_names):
    if brand == "Nike":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion"])

    return group_category_names

def check_type_for_group_category_name(type, group_category_names):
    if type == "Belt":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion"])
    elif type == "Blouse":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Women's Fashion"])
    elif type == "Bomber Jacket":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion"])
    elif type == "Boots":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Women's Fashion"])
    elif type == "Button-up Shirt":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion"])
    elif type == "Cap":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Kid's Fashion"])
    elif type == "Cardigan":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Women's Fashion"])
    elif type == "Cargo Pants":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion"])
    elif type == "Coat":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Women's Fashion"])
    elif type == "Corduroy Pants":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Kid's Fashion"])
    elif type == "Cover-up":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Kid's Fashion"])
    elif type == "Crop Top":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Women's Fashion"])
    elif type == "Culottes":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Women's Fashion"])
    elif type == "Chinos":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion"])
    elif type == "Denim Jacket":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion", "Kid's Fashion"])
    elif type == "Denim Shirt":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion"])
    elif type == "Dress":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Women's Fashion", "Kid's Fashion"])
    elif type == "Dress Pants":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion"])
    elif type == "Dress Shirt":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Women's Fashion"])
    elif type == "Flannel Shirt":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion"])
    elif type == "Fleece Jacket":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion"])
    elif type == "Flip-Flops":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Women's Fashion", "Kid's Fashion"])
    elif type == "Henley Shirt":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion"])
    elif type == "Hoodie":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion", "Kid's Fashion"])
    elif type == "Jacket":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion", "Kid's Fashion"])
    elif type == "Jeans":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion", "Kid's Fashion"])
    elif type == "Joggers":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion", "Kid's Fashion"])
    elif type == "Knitwear":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Women's Fashion"])
    elif type == "Kurta":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion"])
    elif type == "Leggings":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Women's Fashion"])
    elif type == "Loafers":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion"])
    elif type == "Maxi Dress":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Women's Fashion"])
    elif type == "Midi Dress":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Women's Fashion"])
    elif type == "Overalls":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Kid's Fashion"])
    elif type == "Overshirt":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion"])
    elif type == "Parka":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion"])
    elif type == "Polo Shirt":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion", "Kid's Fashion"])
    elif type == "Puffer Jacket":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Kid's Fashion"])
    elif type == "Raincoat":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Women's Fashion", "Kid's Fashion"])
    elif type == "Rash Guard":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Kid's Fashion"])
    elif type == "Running Shoes":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion"])
    elif type == "Sandals":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion", "Kid's Fashion"])
    elif type == "Scarf":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Women's Fashion"])
    elif type == "Shorts":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion", "Kid's Fashion"])
    elif type == "Skirt":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Women's Fashion", "Kid's Fashion"])
    elif type == "Slim-Fit Trousers":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion"])
    elif type == "Sneakers":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion", "Kid's Fashion"])
    elif type == "Softshell Jacket":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Kid's Fashion"])
    elif type == "Sports Jacket":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion"])
    elif type == "Sweater":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion"])
    elif type == "Swim Shorts":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Kid's Fashion"])
    elif type == "Swimsuit":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion", "Kid's Fashion"])
    elif type == "Tote Bag":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Women's Fashion"])
    elif type == "T-shirt":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion", "Kid's Fashion"])
    elif type == "Tunic":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Women's Fashion"])
    elif type == "Track Pants":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion"])
    elif type == "Trench Coat":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Women's Fashion"])
    elif type == "Utility Coat":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Kid's Fashion"])
    elif type == "Vest":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion"])
    elif type == "Water Shoes":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Kid's Fashion"])
    elif type == "Wide-Leg Pants":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Women's Fashion"])
    elif type == "Windbreaker":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion"])
    elif type == "Wool Coat":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Women's Fashion"])

    return group_category_names

def check_topic_for_group_category_name(topic, group_category_names):
    if "Athleisure" in topic and "Lifestyle" in topic:
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion", "Kid's Fashion"])
    elif "Athleisure" in topic and "Performance" in topic:
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion"])
    elif "Lifestyle" in topic:
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion", "Kid's Fashion"])
    elif "Performance" in topic:
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion"])
    elif "Athleisure" in topic:
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion", "Kid's Fashion"])
    elif "Business Casual" in topic or "Modern Workwear" in topic:
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion"])
    elif "Casual" in topic and "Everyday Essential" in topic:
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion"])
    elif "Casual" in topic and "Kids Everyday" in topic:
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Kid's Fashion"])
    elif "Casual" in topic:
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion", "Kid's Fashion"])
    elif "Everyday Essential" in topic:
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion"])
    elif "Kids Everyday" in topic:
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Kid's Fashion"])
    elif "Cultural" in topic or "Festive Wear" in topic:
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion"])
    elif "Eco-Friendly" in topic or "Conscious Choice" in topic:
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Women's Fashion", "Kid's Fashion"])
    elif "Luxury" in topic or "Statement Piece" in topic:
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion", "Kid's Fashion"])
    elif "Minimalist" in topic or "Clean Design" in topic:
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion", "Kid's Fashion"])
    elif "Seasonal" in topic and "Summer & Swim" in topic:
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion", "Kid's Fashion"])
    elif "Seasonal" in topic and "Weather-Ready" in topic:
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion", "Kid's Fashion"])
    elif "Seasonal" in topic:
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion", "Kid's Fashion"])
    elif "Summer & Swim" in topic:
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion", "Kid's Fashion"])
    elif "Weather-Ready" in topic:
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion", "Kid's Fashion"])
    elif "Streetwear" in topic or "Urban Essential" in topic:
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion", "Kid's Fashion"])
    elif "Sustainable" in topic or "Core Essential" in topic:
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion", "Kid's Fashion"])
    elif "Vintage" in topic or "Retro" in topic or "Heritage Style":
        group_category_names = remove_group_category_name(group_category_names=group_category_names, valid_group_category_names=["Men's Fashion", "Women's Fashion", "Kid's Fashion"])

    return group_category_names

def remove_category(categories, valid_categories):
    for category in categories:
        if category not in valid_categories:
            try:
                categories.remove(category)
            except ValueError:
                pass

    return categories

def check_group_category_name_for_category(group_category_name, categories):
    if group_category_name == "Men's Fashion":
        categories = remove_category(categories, valid_categories=["Accessories", "Outerwear", "Pants", "Shirts", "Shoes", "Swimwear"])
    elif group_category_name == "Women's Fashion":
        categories = remove_category(categories, valid_categories=["Accessories", "Dresses", "Outerwear", "Pants", "Shirts", "Shoes"])

    return categories

def check_brand_for_category(brand, categories):
    if brand == "Adidas":
        categories = remove_category(categories, valid_categories=["Dresses", "Outerwear", "Pants", "Shirts", "Shoes"])
    elif brand == "Biti's":
        categories = remove_category(categories, valid_categories=["Outerwear", "Shirts", "Shoes"])
    elif brand == "Bloom":
        categories = remove_category(categories, valid_categories=["Dresses", "Pants", "Shirts", "Shoes"])
    elif brand == "Coolmate":
        categories = remove_category(categories, valid_categories=["Outerwear", "Pants", "Shirts", "Shoes"])
    elif brand == "Everest":
        categories = remove_category(categories, valid_categories=["Outerwear", "Pants", "Shirts", "Shoes"])
    elif brand == "Gucci":
        categories = remove_category(categories, valid_categories=["Accessories", "Dresses", "Outerwear", "Pants", "Shirts", "Shoes"])
    elif brand == "H&M":
        categories = remove_category(categories, valid_categories=["Accessories", "Dresses", "Outerwear", "Pants", "Shirts", "Shoes", "Swimwear"])
    elif brand == "Nike":
        categories = remove_category(categories, valid_categories=["Dresses", "Outerwear", "Pants", "Shirts", "Shoes"])
    elif brand == "Puma":
        categories = remove_category(categories, valid_categories=["Dresses", "Outerwear", "Pants", "Shirts", "Shoes"])
    elif brand == "Routine":
        categories = remove_category(categories, valid_categories=["Outerwear", "Pants", "Shirts", "Shoes", "Swimwear"])
    elif brand == "Uniqlo":
        categories = remove_category(categories, valid_categories=["Dresses", "Outerwear", "Pants", "Shirts", "Shoes", "Swimwear"])
    elif brand == "Zara":
        categories = remove_category(categories, valid_categories=["Dresses", "Outerwear", "Pants", "Shirts", "Shoes"])
    return categories

def check_type_for_category(type, categories):
    if type == "Belt":
        categories = remove_category(categories, valid_categories=["Accessories"])
    elif type == "Blouse":
        categories = remove_category(categories, valid_categories=["Shirts"])
    elif type == "Bomber Jacket":
        categories = remove_category(categories, valid_categories=["Outerwear"])
    elif type == "Boots":
        categories = remove_category(categories, valid_categories=["Shoes"])
    elif type == "Button-up Shirt":
        categories = remove_category(categories, valid_categories=["Shirts"])
    elif type == "Cap":
        categories = remove_category(categories, valid_categories=["Accessories"])
    elif type == "Cardigan":
        categories = remove_category(categories, valid_categories=["Outerwear"])
    elif type == "Cargo Pants":
        categories = remove_category(categories, valid_categories=["Pants"])
    elif type == "Coat":
        categories = remove_category(categories, valid_categories=["Outerwear"])
    elif type == "Corduroy Pants":
        categories = remove_category(categories, valid_categories=["Pants"])
    elif type == "Cover-up":
        categories = remove_category(categories, valid_categories=["Swimwear"])
    elif type == "Crop Top":
        categories = remove_category(categories, valid_categories=["Shirts"])
    elif type == "Culottes":
        categories = remove_category(categories, valid_categories=["Pants"])
    elif type == "Chinos":
        categories = remove_category(categories, valid_categories=["Pants"])
    elif type == "Denim Jacket":
        categories = remove_category(categories, valid_categories=["Outerwear"])
    elif type == "Denim Shirt":
        categories = remove_category(categories, valid_categories=["Shirts"])
    elif type == "Dress":
        categories = remove_category(categories, valid_categories=["Dresses"])
    elif type == "Dress Pants":
        categories = remove_category(categories, valid_categories=["Pants"])
    elif type == "Dress Shirt":
        categories = remove_category(categories, valid_categories=["Shirts"])
    elif type == "Flannel Shirt":
        categories = remove_category(categories, valid_categories=["Shirts"])
    elif type == "Fleece Jacket":
        categories = remove_category(categories, valid_categories=["Outerwear"])
    elif type == "Flip-Flops":
        categories = remove_category(categories, valid_categories=["Shoes"])
    elif type == "Henley Shirt":
        categories = remove_category(categories, valid_categories=["Shirts"])
    elif type == "Hoodie":
        categories = remove_category(categories, valid_categories=["Outerwear"])
    elif type == "Jacket":
        categories = remove_category(categories, valid_categories=["Outerwear"])
    elif type == "Jeans":
        categories = remove_category(categories, valid_categories=["Pants"])
    elif type == "Joggers":
        categories = remove_category(categories, valid_categories=["Pants"])
    elif type == "Knitwear":
        categories = remove_category(categories, valid_categories=["Outerwear"])
    elif type == "Kurta":
        categories = remove_category(categories, valid_categories=["Shirts"])
    elif type == "Leggings":
        categories = remove_category(categories, valid_categories=["Pants"])
    elif type == "Loafers":
        categories = remove_category(categories, valid_categories=["Shoes"])
    elif type == "Maxi Dress":
        categories = remove_category(categories, valid_categories=["Dresses"])
    elif type == "Midi Dress":
        categories = remove_category(categories, valid_categories=["Dresses"])
    elif type == "Overalls":
        categories = remove_category(categories, valid_categories=["Pants"])
    elif type == "Overshirt":
        categories = remove_category(categories, valid_categories=["Shirts"])
    elif type == "Parka":
        categories = remove_category(categories, valid_categories=["Outerwear"])
    elif type == "Polo Shirt":
        categories = remove_category(categories, valid_categories=["Shirts"])
    elif type == "Puffer Jacket":
        categories = remove_category(categories, valid_categories=["Outerwear"])
    elif type == "Raincoat":
        categories = remove_category(categories, valid_categories=["Outerwear"])
    elif type == "Rash Guard":
        categories = remove_category(categories, valid_categories=["Swimwear"])
    elif type == "Running Shoes":
        categories = remove_category(categories, valid_categories=["Shoes"])
    elif type == "Sandals":
        categories = remove_category(categories, valid_categories=["Shoes"])
    elif type == "Scarf":
        categories = remove_category(categories, valid_categories=["Accessories"])
    elif type == "Shorts":
        categories = remove_category(categories, valid_categories=["Pants"])
    elif type == "Skirt":
        categories = remove_category(categories, valid_categories=["Dresses"])
    elif type == "Slim-Fit Trousers":
        categories = remove_category(categories, valid_categories=["Pants"])
    elif type == "Sneakers":
        categories = remove_category(categories, valid_categories=["Shoes"])
    elif type == "Softshell Jacket":
        categories = remove_category(categories, valid_categories=["Outerwear"])
    elif type == "Sports Jacket":
        categories = remove_category(categories, valid_categories=["Outerwear"])
    elif type == "Sweater":
        categories = remove_category(categories, valid_categories=["Outerwear"])
    elif type == "Swim Shorts":
        categories = remove_category(categories, valid_categories=["Swimwear"])
    elif type == "Swimsuit":
        categories = remove_category(categories, valid_categories=["Pants", "Swimwear"])
    elif type == "Tote Bag":
        categories = remove_category(categories, valid_categories=["Accessories"])
    elif type == "T-shirt":
        categories = remove_category(categories, valid_categories=["Shirts"])
    elif type == "Tunic":
        categories = remove_category(categories, valid_categories=["Shirts"])
    elif type == "Track Pants":
        categories = remove_category(categories, valid_categories=["Pants"])
    elif type == "Trench Coat":
        categories = remove_category(categories, valid_categories=["Outerwear"])
    elif type == "Utility Coat":
        categories = remove_category(categories, valid_categories=["Outerwear"])
    elif type == "Vest":
        categories = remove_category(categories, valid_categories=["Outerwear"])
    elif type == "Water Shoes":
        categories = remove_category(categories, valid_categories=["Shoes"])
    elif type == "Wide-Leg Pants":
        categories = remove_category(categories, valid_categories=["Pants"])
    elif type == "Windbreaker":
        categories = remove_category(categories, valid_categories=["Outerwear"])
    elif type == "Wool Coat":
        categories = remove_category(categories, valid_categories=["Outerwear"])
    return categories

def check_topic_for_category(topic, categories):
    if "Athleisure" in topic and "Lifestyle" in topic:
        categories = remove_category(categories, valid_categories=["Outerwear", "Pants", "Shoes"])
    elif "Athleisure" in topic and "Performance" in topic:
        categories = remove_category(categories, valid_categories=["Dresses", "Outerwear", "Pants", "Shirts", "Shoes"])
    elif "Lifestyle" in topic:
        categories = remove_category(categories, valid_categories=["Outerwear", "Pants", "Shoes"])
    elif "Performance" in topic:
        categories = remove_category(categories, valid_categories=["Dresses", "Outerwear", "Pants", "Shirts", "Shoes"])
    elif "Athleisure" in topic:
        categories = remove_category(categories, valid_categories=["Dresses", "Outerwear", "Pants", "Shirts", "Shoes"])
    elif "Business Casual" in topic or "Modern Workwear" in topic:
        categories = remove_category(categories, valid_categories=["Outerwear", "Pants", "Shirts", "Shoes"])
    elif "Casual" in topic and "Everyday Essential" in topic:
        categories = remove_category(categories, valid_categories=["Outerwear", "Pants", "Shirts", "Shoes"])
    elif "Casual" in topic and "Kids Everyday" in topic:
        categories = remove_category(categories, valid_categories=["Outerwear", "Pants", "Shirts", "Shoes"])
    elif "Casual" in topic:
        categories = remove_category(categories, valid_categories=["Outerwear", "Pants", "Shirts", "Shoes"])
    elif "Everyday Essential" in topic:
        categories = remove_category(categories, valid_categories=["Outerwear", "Pants", "Shirts", "Shoes"])
    elif "Kids Everyday" in topic:
        categories = remove_category(categories, valid_categories=["Outerwear", "Pants", "Shirts", "Shoes"])
    elif "Cultural" in topic or "Festive Wear" in topic:
        categories = remove_category(categories, valid_categories=["Shirts"])
    elif "Eco-Friendly" in topic or "Conscious Choice" in topic:
        categories = remove_category(categories, valid_categories=["Shirts"])
    elif "Luxury" in topic or "Statement Piece" in topic:
        categories = remove_category(categories, valid_categories=["Accessories", "Dresses", "Outerwear", "Pants", "Shirts", "Shoes"])
    elif "Minimalist" in topic or "Clean Design" in topic:
        categories = remove_category(categories, valid_categories=["Shoes"])
    elif "Seasonal" in topic and "Summer & Swim" in topic:
        categories = remove_category(categories, valid_categories=["Accessories", "Dresses", "Pants", "Shirts", "Shoes", "Swimwear"])
    elif "Seasonal" in topic and "Weather-Ready" in topic:
        categories = remove_category(categories, valid_categories=["Outerwear", "Pants", "Shirts"])
    elif "Seasonal" in topic:
        categories = remove_category(categories, valid_categories=["Accessories", "Dresses", "Pants", "Shirts", "Shoes", "Swimwear"])
    elif "Summer & Swim" in topic:
        categories = remove_category(categories, valid_categories=["Accessories", "Dresses", "Pants", "Shirts", "Shoes", "Swimwear"])
    elif "Weather-Ready" in topic:
        categories = remove_category(categories, valid_categories=["Outerwear", "Pants", "Shirts"])
    elif "Streetwear" in topic or "Urban Essential" in topic:
        categories = remove_category(categories, valid_categories=["Outerwear", "Pants", "Shirts", "Shoes"])
    elif "Sustainable" in topic or "Core Essential" in topic:
        categories = remove_category(categories, valid_categories=["Dresses", "Outerwear", "Pants", "Shirts", "Shoes", "Swimwear"])
    elif "Vintage" in topic or "Retro" in topic or "Heritage Style":
        categories = remove_category(categories, valid_categories=["Dresses", "Outerwear", "Pants", "Shirts", "Shoes"])

    return categories

#####################################################################

# def display_promotions_with_type(type):
#     if len(type) == 2:
#         query = """
#                 SELECT id, price_limit, max_discount, description
#                 FROM promotions
#                 """
#         result = DatabaseManager.execute_query(query=query, params=None)
#         promotions = []
#
#         for row in result:
#             promotions.append(row['description'])
#
#         return promotions
#     elif len(type) == 1:
#         if "Order" in type:
#             query = """
#                     SELECT id, price_limit, max_discount, description
#                     FROM promotions
#                     WHERE type = "order_discount"
#                     """
#             result = DatabaseManager.execute_query(query=query, params=None)
#             promotions = []
#
#             for row in result:
#                 promotions.append(row['description'])
#
#             return promotions
#         elif "Delivery" in type:
#             query = """
#                     SELECT id, price_limit, max_discount, description
#                     FROM promotions
#                     WHERE type = "shipping_discount"
#                     """
#             result = DatabaseManager.execute_query(query=query, params=None)
#             promotions = []
#
#             for row in result:
#                 promotions.append(row['description'])
#
#             return promotions
#
# def display_promotions_with_price(price, price_description):
#     if len(price) == 2:
#         query = """
#             SELECT id, price_limit, max_discount, description
#             FROM promotions
#             WHERE price_limit BETWEEN %s AND %s
#         """
#
#         result = DatabaseManager.execute_query(query=query, params=tuple(price))
#         promotions = []
#
#         for row in result:
#             promotions.append(row['description'])
#
#         return promotions
#     elif len(price) == 1:
#         if price_description:
#             if "Under" in price_description:
#                 if "Equal" in price_description:
#                     query = """
#                             SELECT id, price_limit, max_discount, description
#                             FROM promotions
#                             WHERE price_limit <= %s
#                             """
#                     result = DatabaseManager.execute_query(query=query, params=tuple(price))
#                     promotions = []
#
#                     for row in result:
#                         promotions.append(row['description'])
#
#                     return promotions
#                 else:
#                     query = """
#                             SELECT id, price_limit, max_discount, description
#                             FROM promotions
#                             WHERE price_limit < %s
#                             """
#                     result = DatabaseManager.execute_query(query=query, params=tuple(price))
#                     promotions = []
#
#                     for row in result:
#                         promotions.append(row['description'])
#
#                     return promotions
#             elif "Above" in price_description:
#                 query = """
#                         SELECT id, price_limit, max_discount, description
#                         FROM promotions
#                         WHERE price_limit <= %s
#                         """
#                 result = DatabaseManager.execute_query(query=query, params=tuple(price))
#                 promotions = []
#
#                 for row in result:
#                     promotions.append(row['description'])
#
#                 return promotions
#         else:
#             query = """
#                     SELECT id, price_limit, max_discount, description
#                     FROM promotions
#                     WHERE price_limit <= %s
#                     """
#             result = DatabaseManager.execute_query(query=query, params=tuple(price))
#             promotions = []
#
#             for row in result:
#                 promotions.append(row['description'])
#
#             return promotions
#
# def display_promotions_with_type_and_price(type, price, price_description):
#     if len(price) == 2:
#         if len(type) == 2:
#             query = """
#                     SELECT id, price_limit, max_discount, description
#                     FROM promotions
#                     WHERE price_limit BETWEEN %s AND %s"
#                     """
#             result = DatabaseManager.execute_query(query=query, params=tuple(price))
#             promotions = []
#
#             for row in result:
#                 promotions.append(row['description'])
#
#             return promotions
#         elif len(type) == 1:
#             if "Order" in type:
#                 query = """
#                         SELECT id, price_limit, max_discount, description
#                         FROM promotions
#                         WHERE price_limit BETWEEN %s AND %s AND type = "order_discount"
#                         """
#                 result = DatabaseManager.execute_query(query=query, params=tuple(price))
#                 promotions = []
#
#                 for row in result:
#                     promotions.append(row['description'])
#
#                 return promotions
#             elif "Delivery" in type:
#                 query = """
#                         SELECT id, price_limit, max_discount, description
#                         FROM promotions
#                         WHERE price_limit BETWEEN %s AND %s AND type = "shipping_discount"
#                         """
#                 result = DatabaseManager.execute_query(query=query, params=tuple(price))
#                 promotions = []
#
#                 for row in result:
#                     promotions.append(row['description'])
#
#                 return promotions
#     elif len(price) == 1:
#         if len(type) == 2:
#             if price_description:
#                 if "Under" in price_description:
#                     if "Equal" in price_description:
#                         query = """
#                                 SELECT id, price_limit, max_discount, description
#                                 FROM promotions
#                                 WHERE price_limit <= %s
#                                 """
#                         result = DatabaseManager.execute_query(query=query, params=tuple(price))
#                         promotions = []
#
#                         for row in result:
#                             promotions.append(row['description'])
#
#                         return promotions
#                     else:
#                         query = """
#                                 SELECT id, price_limit, max_discount, description
#                                 FROM promotions
#                                 WHERE price_limit < %s
#                                 """
#                         result = DatabaseManager.execute_query(query=query, params=tuple(price))
#                         promotions = []
#
#                         for row in result:
#                             promotions.append(row['description'])
#
#                         return promotions
#                 elif "Above" in price_description:
#                     query = """
#                             SELECT id, price_limit, max_discount, description
#                             FROM promotions
#                             WHERE price_limit <= %s
#                             """
#                     result = DatabaseManager.execute_query(query=query, params=tuple(price))
#                     promotions = []
#
#                     for row in result:
#                         promotions.append(row['description'])
#
#                     return promotions
#             else:
#                 query = """
#                         SELECT id, price_limit, max_discount, description
#                         FROM promotions
#                         WHERE price_limit <= %s
#                         """
#                 result = DatabaseManager.execute_query(query=query, params=tuple(price))
#                 promotions = []
#
#                 for row in result:
#                     promotions.append(row['description'])
#
#                 return promotions
#         elif len(type) == 1:
#             if "Order" in type:
#                 if price_description:
#                     if "Under" in price_description:
#                         if "Equal" in price_description:
#                             query = """
#                                     SELECT id, price_limit, max_discount, description
#                                     FROM promotions
#                                     WHERE price_limit <= %s AND type = "order_discount"
#                                     """
#                             result = DatabaseManager.execute_query(query=query, params=tuple(price))
#                             promotions = []
#
#                             for row in result:
#                                 promotions.append(row['description'])
#
#                             return promotions
#                         else:
#                             query = """
#                                     SELECT id, price_limit, max_discount, description
#                                     FROM promotions
#                                     WHERE price_limit < %s AND type = "order_discount"
#                                     """
#                             result = DatabaseManager.execute_query(query=query, params=tuple(price))
#                             promotions = []
#
#                             for row in result:
#                                 promotions.append(row['description'])
#
#                             return promotions
#                     elif "Above" in price_description:
#                         query = """
#                                 SELECT id, price_limit, max_discount, description
#                                 FROM promotions
#                                 WHERE price_limit <= %s AND type = "order_discount"
#                                 """
#                         result = DatabaseManager.execute_query(query=query, params=tuple(price))
#                         promotions = []
#
#                         for row in result:
#                             promotions.append(row['description'])
#
#                         return promotions
#                 else:
#                     query = """
#                             SELECT id, price_limit, max_discount, description
#                             FROM promotions
#                             WHERE price_limit <= %s AND type = "order_discount"
#                             """
#                     result = DatabaseManager.execute_query(query=query, params=tuple(price))
#                     promotions = []
#
#                     for row in result:
#                         promotions.append(row['description'])
#
#                     return promotions
#             elif "Delivery" in type:
#                 if price_description:
#                     if "Under" in price_description:
#                         if "Equal" in price_description:
#                             query = """
#                                     SELECT id, price_limit, max_discount, description
#                                     FROM promotions
#                                     WHERE price_limit <= %s AND type = "shipping_discount"
#                                     """
#                             result = DatabaseManager.execute_query(query=query, params=tuple(price))
#                             promotions = []
#
#                             for row in result:
#                                 promotions.append(row['description'])
#
#                             return promotions
#                         else:
#                             query = """
#                                     SELECT id, price_limit, max_discount, description
#                                     FROM promotions
#                                     WHERE price_limit < %s AND type = "shipping_discount"
#                                     """
#                             result = DatabaseManager.execute_query(query=query, params=tuple(price))
#                             promotions = []
#
#                             for row in result:
#                                 promotions.append(row['description'])
#
#                             return promotions
#                     elif "Above" in price_description:
#                         query = """
#                                 SELECT id, price_limit, max_discount, description
#                                 FROM promotions
#                                 WHERE price_limit <= %s AND type = "shipping_discount"
#                                 """
#                         result = DatabaseManager.execute_query(query=query, params=tuple(price))
#                         promotions = []
#
#                         for row in result:
#                             promotions.append(row['description'])
#
#                         return promotions
#                 else:
#                     query = """
#                             SELECT id, price_limit, max_discount, description
#                             FROM promotions
#                             WHERE price_limit <= %s AND type = "shipping_discount"
#                             """
#                     result = DatabaseManager.execute_query(query=query, params=tuple(price))
#                     promotions = []
#
#                     for row in result:
#                         promotions.append(row['description'])
#
#                     return promotions

#####################################################################
# Template for size chart
size_chart = {
    # ==================== NAM ====================
    "Men's Fashion": {
        # Áp dụng cho: Quần, Áo, Áo khoác, Đồ bơi
        "apparel": [
            {
                "size": "S", "value": 1,
                "height_min": 160, "height_max": 168,
                "weight_min": 55, "weight_max": 62
            },
            {
                "size": "M", "value": 2,
                "height_min": 169, "height_max": 174,
                "weight_min": 63, "weight_max": 70
            },
            {
                "size": "L", "value": 3,
                "height_min": 175, "height_max": 179,
                "weight_min": 71, "weight_max": 78
            },
            {
                "size": "XL", "value": 4,
                "height_min": 180, "height_max": 185,
                "weight_min": 79, "weight_max": 85
            }
        ],
        # Áp dụng cho Giày
        "shoes": [
            {
                "size": 40,
                "foot_length_min": 24.6, "foot_length_max": 25.0
            },
            {
                "size": 41,
                "foot_length_min": 25.1, "foot_length_max": 25.5
            },
            {
                "size": 42,
                "foot_length_min": 25.6, "foot_length_max": 26.0
            },
            {
                "size": 43,
                "foot_length_min": 26.1, "foot_length_max": 26.5
            }
        ]
    },

    # ==================== NỮ ====================
    "Women's Fashion": {
        # Áp dụng cho: Quần, Áo, Áo khoác, Đồ bơi, Váy
        "apparel": [
            {
                "size": "S", "value": 1,
                "height_min": 150, "height_max": 155,
                "weight_min": 40, "weight_max": 47
            },
            {
                "size": "M", "value": 2,
                "height_min": 156, "height_max": 160,
                "weight_min": 48, "weight_max": 54
            },
            {
                "size": "L", "value": 3,
                "height_min": 161, "height_max": 165,
                "weight_min": 55, "weight_max": 60
            },
            {
                "size": "XL", "value": 4,
                "height_min": 166, "height_max": 170,
                "weight_min": 61, "weight_max": 66
            }
        ],
        # Áp dụng cho Giày
        "shoes": [
            {
                "size": 36,
                "foot_length_min": 22.1, "foot_length_max": 22.5
            },
            {
                "size": 37,
                "foot_length_min": 22.6, "foot_length_max": 23.0
            },
            {
                "size": 38,
                "foot_length_min": 23.1, "foot_length_max": 23.5
            },
            {
                "size": 39,
                "foot_length_min": 23.6, "foot_length_max": 24.0
            }
        ]
    },

    # ==================== TRẺ EM ====================
    "Kid's Fashion": {
        # Áp dụng cho: Quần, Áo, Áo khoác, Đồ bơi, Váy
        "apparel": [
            {
                "size": "XS", "value": 1,
                "height_min": 85, "height_max": 95,
                "weight_min": 12, "weight_max": 14
            },
            {
                "size": "S", "value": 2,
                "height_min": 96, "height_max": 110,
                "weight_min": 15, "weight_max": 19
            },
            {
                "size": "M", "value": 3,
                "height_min": 111, "height_max": 120,
                "weight_min": 20, "weight_max": 24
            }
        ],
        # Áp dụng cho Giày
        "shoes": [
            {
                "size": 28,
                "foot_length_min": 17.1, "foot_length_max": 17.7
            },
            {
                "size": 29,
                "foot_length_min": 17.8, "foot_length_max": 18.4
            },
            {
                "size": 30,
                "foot_length_min": 18.5, "foot_length_max": 19.0
            },
            {
                "size": 31,
                "foot_length_min": 19.1, "foot_length_max": 19.7
            }
        ]
    }
}


#####################################################################
class DatabaseManager:
    """Utility class for managing database connections and queries"""

    @staticmethod
    @contextmanager
    def get_db_connection():
        """Context manager for database connections"""
        connection = None
        try:
            connection = mysql.connector.connect(**DB_CONFIG)
            print("Connect to database successfully")
            yield connection
        except Error as e:
            logger.error(f"Database connection error: {e}")
            print("Error")
            raise
        finally:
            if connection and connection.is_connected():
                connection.close()

    @staticmethod
    def execute_query(query: str, params: tuple = None) -> List[Dict]:
        """Execute a SELECT query and return results as list of dictionaries"""
        try:
            with DatabaseManager.get_db_connection() as connection:
                cursor = connection.cursor(dictionary=True)
                cursor.execute(query, params or ())
                results = cursor.fetchall()
                cursor.close()
                return results
        except Error as e:
            logger.error(f"Query execution error: {e}")
            return []

    @staticmethod
    def call_stored_procedure(procedure_name: str, params: tuple = None, fetch_results: bool = True) -> List[Dict]:
        """
        Call a stored procedure and return results

        Args:
            procedure_name (str): Name of the stored procedure
            params (tuple): Parameters to pass to the stored procedure
            fetch_results (bool): Whether to fetch and return results

        Returns:
            List[Dict]: Results from the stored procedure (if fetch_results=True)
        """
        try:
            with DatabaseManager.get_db_connection() as connection:
                cursor = connection.cursor(dictionary=True)

                # Call the stored procedure
                cursor.callproc(procedure_name, params or ())

                results = []
                if fetch_results:
                    # Fetch results from all result sets
                    for result_set in cursor.stored_results():
                        results.extend(result_set.fetchall())

                # Commit if there are any changes (for procedures that modify data)
                connection.commit()
                cursor.close()

                print("Got result from stored procedure")
                return results

        except Error as e:
            print("Error in stored procedure")
            logger.error(f"Stored procedure execution error: {e}")
            return []


class ActionAskGemini(Action):
    def name(self) -> Text:
        return "action_ask_gemini"

    def call_llm_model(prompt):
        llm_model = genai.GenerativeModel(
            model_name="gemini-2.5-flash",
            generation_config={"temperature": 0.7}
        )
        chat = llm_model.start_chat(history=[])
        response = chat.send_message(prompt)

        return response

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        prompt = tracker.latest_message()

        try:
            response = ActionAskGemini.call_llm_model(prompt)

            dispatcher.utter_message(text=response.text)
            print(response.text)

        except Exception as e:
            dispatcher.utter_message(text=f"Sorry, It seems like there is an error. (Error: {e})")

        return []

class ActionShowTime(Action):
    def name(self) -> Text:
        return "action_show_time"

    def run(
        self,
        dispatcher: CollectingDispatcher,
        tracker: Tracker,
        domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:

        dispatcher.utter_message(text=f"It is currently: {dt.datetime.now()}")
        return []

class ActionGeneralPromotions(Action):
    def name(self) -> Text:
        return "action_general_promotions"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        promo_text = "There are one for order and one for delivery"
        dispatcher.utter_message(text=promo_text)
        return []

class ActionDetailPromotions(Action):
    def name(self) -> Text:
        return "action_detail_promotions"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        promotion_type = tracker.get_slot("promotion_type")
        promotion_text = ""

        if promotion_type == "order":
            promotion_text = "There is an order promotion"
            dispatcher.utter_message(text=promotion_text)
        elif promotion_type == "delivery":
            promotion_text = "There is a shipping promotion"
            dispatcher.utter_message(text=promotion_text)

        return []

class ActionGreetCustom(Action):
    def name(self) -> Text:
        return "action_greet_custom"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        text = "Welcome to our shop, I am your Rasa virtual assistant. How can I help you with?"

        buttons = [
            {
                "title": "I am looking for promotions",
                "payload": "promotions"
            },

            {
                "title": "Recommend for me products",
                "payload": "product recommendation"
            },

            {
                "title": "I need help choosing size",
                "payload": "help with size"
            },

            {
                "title": "Check orders' status",
                "payload": "order status tracking"
            },

            {
                "title": "Make refunds",
                "payload": "I want to make a refund"
            },

            # {
            #     "title": "Show new products",
            #     "payload": "new products"
            # },
        ]

        dispatcher.utter_message(text, buttons=buttons)
        return []

class ActionAskGroupCategoryName(Action):
    def name(self) -> Text:
        return "action_ask_group_category_name"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        group_category_names = list_all_group_categories_name()
        category = tracker.get_slot("category")
        brand_name = tracker.get_slot("brand_name")
        type = tracker.get_slot("type")
        topic = tracker.get_slot("topic")

        if category is not None:
            group_category_names = check_category_for_group_category_name(category=category, group_category_names=group_category_names)

        if brand_name is not None:
            group_category_names = check_brand_for_group_category_name(brand=brand_name, group_category_names=group_category_names)

        if type is not None:
            group_category_names = check_type_for_group_category_name(type=type, group_category_names=group_category_names)

        if topic is not None:
            group_category_names = check_topic_for_group_category_name(topic=topic, group_category_names=group_category_names)

        text = ("What type of individual's fashion that you are looking for?\n"
                "Currently, for:\n")
        temp_list = [category, brand_name, type, topic]

        for item in temp_list:
            if item is not None:
                text += f"- {item}\n"

        text += f"Our shop has {len(group_category_names)} option(s):"

        # for group_category_name in group_category_names:
        #     text += f"- {group_category_name}\n"

        buttons = []
        for group_category_name in group_category_names:
            button = {
                "title": f"{group_category_name}",
                "payload": f"{group_category_name}",
                # "postback": f'/provide_group_category_name{{"group_category_name":"{group_category_name}"}}'
            }
            buttons.append(button)

        dispatcher.utter_message(text=text, buttons=buttons)
        return []

class ActionAskCategory(Action):
    def name(self) -> Text:
        return "action_ask_category"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        group_category_name = tracker.get_slot("group_category_name")
        brand_name = tracker.get_slot("brand_name")
        type = tracker.get_slot("type")
        topic = tracker.get_slot("topic")
        height = tracker.get_slot("height")
        weight = tracker.get_slot("weight")
        foot_length = tracker.get_slot("foot_length")
        help_type = tracker.get_slot("help_type")

        categories = list_all_categories()

        if group_category_name:
            categories = check_group_category_name_for_category(group_category_name=group_category_name, categories=categories)
        if brand_name:
            categories = check_brand_for_category(brand=brand_name, categories=categories)
        if type:
            categories = check_type_for_category(type=type, categories=categories)
        if topic:
            categories = check_topic_for_category(topic=topic, categories=categories)
        if height or weight:
            try:
                categories.remove("Shoes")
            except ValueError:
                pass
        if foot_length:
            categories = ["Shoes"]

        if help_type:
            if help_type == "help_size":
                try:
                    categories.remove("Accessories")
                except ValueError:
                    pass

        text = (f"Can you tell me which product category you are interested in?\n"
                f"At the moment, for:\n")

        temp_list = [group_category_name, brand_name, type, topic]
        for item in temp_list:
            if item is not None:
                text += f"- {item}\n"

        text += f"Our shop has {len(categories)} option(s):\n"

        # for category in categories:
        #     text += f"- {category}\n"

        buttons = []
        for category in categories:
            button = {
                "title": f"{category}",
                "payload": f"{category}",
                # "postback": f'/provide_category{{"category":"{category}"}}'
            }
            buttons.append(button)

        dispatcher.utter_message(text=text, buttons=buttons)
        return []

class ActionAskBrand(Action):
    def name(self) -> Text:
        return "action_ask_brand_name"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        # category = tracker.get_slot("category")
        # clothes_brands = ["H&M", "Zara", "Gucci"]
        # shoes_brands = ["Nike", "Adidas"]
        #
        # clothes = ["Shirts", "Pants"]
        # shoes = ["Shoes"]
        # buttons = []

        # Handle for shirt and pants
        # if category in clothes:
        #     text = ("Now, can you tell me which brand you are looking for?\n"
        #             f"For {category}, we currently have {len(clothes_brands)} brands:\n")
        #
        #     for brand in clothes_brands:
        #         text += f"- {brand}\n"
        #
        #     for clothes_brand in clothes_brands:
        #         button = {
        #             "title": f"{clothes_brand}",
        #             "payload": f"{clothes_brand}",
        #             "postback": f'/provide_brand_name{{"brand_name":"{clothes_brand}"}}'
        #         }
        #         buttons.append(button)
        #
        # # Handle for shoes
        # elif category in shoes:
        #     text = ("Now, can you tell me which brand you are looking for?\n"
        #             f"For {category}, we currently have {len(shoes_brands)} brands:\n")
        #
        #     for brand in shoes_brands:
        #         text += f"- {brand}\n"
        #
        #     for shoes_brand in shoes_brands:
        #         button = {
        #             "title": f"{shoes_brand}",
        #             "payload": f"{shoes_brand}",
        #             "postback": f'/provide_brand_name{{"brand_name":"{shoes_brand}"}}'
        #         }
        #         buttons.append(button)

        brands = list_all_brands()
        group_category_name = tracker.get_slot("group_category_name")
        category = tracker.get_slot("category")
        type = tracker.get_slot("type")
        topic = tracker.get_slot("topic")

        if group_category_name:
            brands = check_group_category_for_brand(group_category_name=group_category_name, brands=brands)

        if category:
            brands = check_category_for_brand(category=category, brands=brands)

        if type:
            brands = check_type_for_brand(type=type, brands=brands)

        if topic:
            brands = check_topic_for_brand(topic=topic, brands=brands)

        text = ("Which brand are you looking for?\n"
                f"Currently, for:\n")

        temp_list = [group_category_name, category, type, topic]
        for item in temp_list:
            if item is not None:
                text += f"- {item}\n"

        text += f"Our shop has {len(brands)} brands:\n"
        buttons = []

        for brand in brands:
            text += f"- {brand}\n"
            button = {
                "title": f"{brand}",
                "payload": f"{brand}"
            }
            buttons.append(button)

        dispatcher.utter_message(text=text, buttons=buttons)
        return []

class ActionAskKnowsSize(Action):
    def name(self) -> Text:
        return "action_ask_knows_size"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        brand = tracker.get_slot("brand_name")
        category = tracker.get_slot("category")

        text = f"Have you ever worn {category.lower()} of {brand}?"
        buttons = [
            {
                "title": f"I've worn this product this brand before",
                "payload": "Yes"
            },

            {
                "title": "No I haven't worn product of this brand",
                "payload": "No"
            }
        ]

        dispatcher.utter_message(text=text, buttons=buttons)
        return []

class ActionAskClothesSize(Action):
    def name(self) -> Text:
        return "action_ask_clothes_size"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        brand = tracker.get_slot("brand_name")
        category = tracker.get_slot("category")

        text = f"What is your usual size of {category} for {brand.title()} ?"
        dispatcher.utter_message(text=text)
        return []

class ActionAskHeight(Action):
    def name(self) -> Text:
        return "action_ask_height"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        brand = tracker.get_slot("brand_name")
        text = (f"It's ok if you don't know about the size information of brand {brand}\n"
                f"Can you tell me about your height in cm?")

        dispatcher.utter_message(text=text)
        return []

class ActionAskWeight(Action):
    def name(self) -> Text:
        return "action_ask_weight"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        text = f"Great, now what about your weight in kg?"

        dispatcher.utter_message(text=text)
        return []

class ActionAskShoesSize(Action):
    def name(self) -> Text:
        return "action_ask_shoes_size"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        brand = tracker.get_slot("brand_name")
        text = f"What is your usual shoes size for {brand}?"
        dispatcher.utter_message(text=text)
        return []

class ActionAskKnowsFootLength(Action):
    def name(self) -> Text:
        return "action_ask_knows_foot_length"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        text = "Can I ask that do you know how to measure your foot length?"
        buttons = [
            {
                "title": "Yes, I do know how to",
                "payload": "Yes"
            },

            {
                "title": "No, I don't know how to",
                "payload": "No"
            }
        ]

        dispatcher.utter_message(text=text, buttons=buttons)

        return []

class ActionAskFootLength(Action):
    def name(self) -> Text:
        return "action_ask_foot_length"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        text = ("If you have already known about the length of your foot.\n"
                "Please provide the information about your foot length in centimeter (cm)")
        dispatcher.utter_message(text=text)
        return []

class ActionGenerateSizeRecommendation(Action):
    def name(self) -> Text:
        return "action_generate_size_recommendation"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        group_category_name = tracker.get_slot("group_category_name")
        category = tracker.get_slot("category")
        brand_name = tracker.get_slot("brand_name")
        knows_size = tracker.get_slot("knows_size")
        knows_foot_length = tracker.get_slot("knows_foot_length")

        text = ("With all the information that you provided for me:\n"
                f"- {group_category_name}\n"
                f"- {category}\n"
                f"- {brand_name}\n")

        if knows_size == True:
            clothes_size = tracker.get_slot("clothes_size")
            shoes_size = tracker.get_slot("shoes_size")

            if clothes_size:
                text += f"And you used to wear clothes of {brand_name}, with size: {clothes_size}\n"
                text += f"Therefore, I think that size {clothes_size} should fit you best."
            else:
                text += f"And you used to wear shoes of {brand_name}, with size: {shoes_size}\n"
                text += f"Therefore, I think that size {shoes_size} should fit you best."

        # elif knows_foot_length == True:
        #     shoes_size = tracker.get_slot("shoes_size")
        #     text += f"And you used to wear shoes of {brand_name}, with size: {shoes_size}\n"
        #     text += f"Therefore, I think that {shoes_size} should fit you best."
        else:
            height = tracker.get_slot("height")
            weight = tracker.get_slot("weight")
            foot_length = tracker.get_slot("foot_length")

            if height and weight:
                height = float(height)
                weight = float(weight)

                print("Reached in generate size recommendation")

                size_list = size_chart[group_category_name]["apparel"]
                height_size = ""
                weight_size = ""
                height_size_value = 0
                weight_size_value = 0

                for size_info in size_list:
                    if (size_info["height_min"] <= height <= size_info["height_max"]) and height_size == "":
                        height_size = size_info["size"]
                        height_size_value = size_info["value"]
                        print(f"Height size: {height_size}")
                    if (size_info["weight_min"] <= weight <= size_info["weight_max"]) and weight_size == "":
                        weight_size = size_info["size"]
                        weight_size_value = size_info["value"]
                        print(f"Weight size: {weight_size}")

                if height_size != "" and weight_size != "":
                    if height_size == weight_size:
                        print("Reached same size of height and weight")
                        text += ("With the measurement information that you gave me:\n"
                                 f"- Height: {height} cm\n"
                                 f"- Weight: {weight} kg\n"
                                 f"I think that the size would suit you best for {category.lower()} is: {height_size}")
                    else:
                        print("Reached different size of height and weight")
                        text += ("With the measurement information that you gave me:\n"
                                 f"- Height: {height} cm\n"
                                 f"- Weight: {weight} kg\n"
                                 f"With your height the best size for you is: {height_size}, and regarding your weight the best size for you is: {weight_size}\n"
                                 f"Therefore, I think that:\n")

                        if height_size_value > weight_size_value:
                            text += (
                                f"+ If you want to wear fit {category.lower()}, the size you need is: {weight_size}\n"
                                f"+ If you prefer more comfortable {category.lower()}, the size suits you best is: {height_size}")
                        elif height_size_value < weight_size_value:
                            text += (
                                f"+ If you want to wear fit {category.lower()}, the size you need is: {height_size}\n"
                                f"+ If you prefer more comfortable {category.lower()}, the size suits you best is: {weight_size}")

                    formatted_text = format_generated_answer(text)
                    dispatcher.utter_message(text=formatted_text)

                    # dispatcher.utter_message(text=text)
                    return [Restarted()]

            elif foot_length:
                print("Reached foot length here")

                foot_length = float(foot_length)
                size_list = size_chart[group_category_name]["shoes"]
                shoes_size = 0

                for size_info in size_list:
                    if size_info["foot_length_min"] <= foot_length <= size_info["foot_length_max"]:
                        shoes_size = size_info["size"]
                        break

                text += ("With the measurement information that you gave me:\n"
                         f"- Foot's length: {foot_length} cm\n"
                         f"I think that the size would suit you best for {category.lower()} is: {shoes_size}")

                formatted_text = format_generated_answer(text)
                dispatcher.utter_message(text=formatted_text)

                # dispatcher.utter_message(text=text)
                return [Restarted()]

        formatted_text = format_generated_answer(text)
        dispatcher.utter_message(text=formatted_text)

        # dispatcher.utter_message(text=text)
        return [Restarted()]

class ValidateSizeForm(FormValidationAction):
    def name(self) -> Text:
        return "validate_size_form"

    async def required_slots(
        self,
        domain_slots: List[Text],
        dispatcher: "CollectingDispatcher",
        tracker: "Tracker",
        domain: "DomainDict",
    ) -> List[Text]:

        updated_slots = domain_slots.copy()

        category = tracker.get_slot("category")
        height = tracker.get_slot("height")
        weight = tracker.get_slot("weight")
        foot_length = tracker.get_slot("foot_length")
        knows_size = tracker.get_slot("knows_size")

        if (height or weight) and knows_size is None:
            updated_slots.remove("knows_size")
            updated_slots.remove("clothes_size")
            updated_slots.remove("shoes_size")
            updated_slots.remove("knows_foot_length")
            updated_slots.remove("foot_length")

        if foot_length and knows_size is None:
            updated_slots.remove("knows_size")
            updated_slots.remove("clothes_size")
            updated_slots.remove("height")
            updated_slots.remove("weight")
            updated_slots.remove("shoes_size")
            updated_slots.remove("knows_foot_length")

        categories = list_all_categories()
        clothes_categories = [c for c in categories if c != "Shoes"]
        shoes_categories = [c for c in categories if c == "Shoes"]

        if knows_size is not None:
            if category in clothes_categories:

                updated_slots.remove("shoes_size")
                updated_slots.remove("knows_foot_length")
                updated_slots.remove("foot_length")

                if knows_size:
                    updated_slots.remove("height")
                    updated_slots.remove("weight")
                else:
                    updated_slots.remove("clothes_size")

            elif category in shoes_categories:

                updated_slots.remove("clothes_size")
                updated_slots.remove("height")
                updated_slots.remove("weight")

                if knows_size:
                    updated_slots.remove("knows_foot_length")
                    updated_slots.remove("foot_length")
                else:
                    updated_slots.remove("shoes_size")
        else:
            pass

        print(f"Updated slots: {updated_slots}")
        return updated_slots

    # async def extract_knows_size(
    #         self,
    #         dispatcher: CollectingDispatcher,
    #         tracker: Tracker,
    #         domain: Dict
    # ) -> Dict[Text, Any]:
    #
    #     knows_size = tracker.get_intent_of_latest_message()
    #     print(f"State of knows size: {knows_size}")
    #
    #     return {"knows_size": None}

    # def slot_mappings(self) -> Dict[Text, Any]:
    #     return {
    #         "knows_size": [
    #             self.from_intent(intent="affirm", value=True),
    #             self.from_intent(intent="deny", value=False)
    #         ]
    #     }

    def validate_group_category_name(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict,
        ) -> Dict[Text, Any]:
        """ Validate the value of group_category_name in required_slots """

        group_category_names = list_all_group_categories_name()
        group_category_name = slot_value

        category = tracker.get_slot("category")
        brand_name = tracker.get_slot("brand_name")
        type = tracker.get_slot("type")
        topic = tracker.get_slot("topic")

        if group_category_name:
            if category:
                group_category_names = check_category_for_group_category_name(category=category, group_category_names=group_category_names)

            if brand_name:
                group_category_names = check_brand_for_group_category_name(brand=brand_name, group_category_names=group_category_names)

            if type:
                group_category_names = check_type_for_group_category_name(type=type, group_category_names=group_category_names)

            if topic:
                group_category_names = check_topic_for_group_category_name(topic=topic, group_category_names=group_category_names)

            if group_category_name in group_category_names:
                height = tracker.get_slot("height")
                weight = tracker.get_slot("weight")
                foot_length = tracker.get_slot("foot_length")

                if height or weight:
                    if height and weight:
                        try:
                            height = float(height)
                        except ValueError:
                            try:
                                weight = float(weight)
                            except ValueError:
                                text = "I am sorry but please check your height and weight information again."
                                dispatcher.utter_message(text=text)
                                return {"group_category_name": group_category_name, "height": None, "weight": None}

                            text = "I am sorry but please check your height information again."
                            dispatcher.utter_message(text=text)
                            return {"group_category_name": group_category_name, "height": None, "weight": weight}
                        try:
                            weight = float(weight)
                        except ValueError:
                            text = "I am sorry but please check your weight information again."
                            dispatcher.utter_message(text=text)
                            return {"group_category_name": group_category_name, "height": height, "weight": None}

                        size_list = size_chart[group_category_name]['apparel']
                        valid_height = False
                        valid_weight = False
                        max_height = size_list[len(size_list) - 1]['height_max']
                        min_height = size_list[0]['height_min']
                        max_weight = size_list[len(size_list) - 1]['weight_max']
                        min_weight = size_list[0]['weight_min']

                        for size_info in size_list:
                            if size_info['height_min'] <= height <= size_info['height_max']:
                                valid_height = True
                            if size_info['weight_min'] <= weight <= size_info['weight_max']:
                                valid_weight = True

                        if valid_height and valid_weight:
                            return {"group_category_name": group_category_name, "height": height, "weight": weight}

                        elif valid_height == False and valid_weight == False:
                            text = ("I am sorry but it seems like you just entered an invalid value for height and weight.\n"
                                    f"Our store only has size for height from {min_height}cm to {max_height}cm\n"
                                    f"Our store only has size for weight from {min_weight}kg to {max_weight}kg")
                            dispatcher.utter_message(text=text)
                            return {"group_category_name": group_category_name, "height": height, "weight": None}

                        elif valid_height:
                            text = ("I am sorry but it seems like you just entered an invalid weight value.\n"
                                    f"Our store only has size for weight from {min_weight}kg to {max_weight}kg")
                            dispatcher.utter_message(text=text)
                            return {"group_category_name": group_category_name, "height": height, "weight": None}

                        elif valid_weight:
                            text = ("I am sorry but it seems like you just entered an invalid height value.\n"
                                    f"Our store only has size for height from {min_height}cm to {max_height}cm")
                            dispatcher.utter_message(text=text)
                            return {"group_category_name": group_category_name, "height": None, "weight": weight}
                    elif height:
                        try:
                            height = float(height)
                        except ValueError:
                            text = "I am sorry but please check your height information again."
                            dispatcher.utter_message(text=text)
                            return {"group_category_name": group_category_name, "height": None}

                        size_list = size_chart[group_category_name]['apparel']
                        valid_height = False
                        max_height = size_list[len(size_list) - 1]['height_max']
                        min_height = size_list[0]['height_min']

                        for size_info in size_list:
                            if size_info['height_min'] <= height <= size_info['height_max']:
                                valid_height = True
                                break

                        if valid_height:
                            return {"group_category_name": group_category_name, "height": height}
                        else:
                            text = ("I am sorry but it seems like you just entered an invalid height value.\n"
                                    f"Our store only has size for height from {min_height}cm to {max_height}cm")
                            dispatcher.utter_message(text=text)
                            return {"group_category_name": group_category_name, "height": None}
                    elif weight:
                        try:
                            weight = float(weight)
                        except ValueError:
                            text = "I am sorry but please check your weight information again."
                            dispatcher.utter_message(text=text)
                            return {"group_category_name": group_category_name, "weight": None}

                        size_list = size_chart[group_category_name]['apparel']
                        valid_weight = False
                        max_weight = size_list[len(size_list) - 1]['weight_max']
                        min_weight = size_list[0]['weight_min']

                        for size_info in size_list:
                            if size_info['weight_min'] <= weight <= size_info['weight_max']:
                                valid_weight = True
                                break

                        if valid_weight:
                            return {"group_category_name": group_category_name, "weight": weight}
                        else:
                            text = ("I am sorry but it seems like you just entered an invalid weight value.\n"
                                    f"Our store only has size for weight from {min_weight}kg to {max_weight}kg")
                            dispatcher.utter_message(text=text)
                            return {"group_category_name": group_category_name, "weight": None}
                elif foot_length:
                    try:
                        foot_length = float(foot_length)
                    except ValueError:
                        text = "I am sorry but please check your foot length information again."
                        dispatcher.utter_message(text=text)
                        return {"group_category_name": group_category_name, "foot_length": None}

                    size_list = size_chart[group_category_name]['shoes']
                    valid_foot_length = False
                    min_foot_length = size_list[0]["foot_length_min"]
                    max_foot_length = size_list[3]["foot_length_max"]

                    for size_info in size_list:
                        if size_info['foot_length_min'] <= foot_length <= size_info['foot_length_max']:
                            valid_foot_length = True
                            break

                    if valid_foot_length:
                        return {"group_category_name": group_category_name, "foot_length": foot_length}
                    else:
                        text = ("I am sorry but it seems like you just entered an invalid foot length value.\n"
                                f"Our store only has size for foot length from {min_foot_length}cm to {max_foot_length}cm")
                        dispatcher.utter_message(text=text)
                        return {"group_category_name": group_category_name, "foot_length": None}

                return {"group_category_name": group_category_name}
            else:
                text = "I am sorry but apparently for:\n"
                temp_list = [category, brand_name, type, topic]

                for item in temp_list:
                    if item is not None:
                        text += f"- {item}\n"
                text += f"We don't have: {group_category_name}"
                dispatcher.utter_message(text=text)
                return {"group_category_name": None}
        # if group_category_name in group_category_names:
        #     if category:
        #         if (category == "Dresses" and group_category_name == "Men's Fashion") or (category == "Swimwear" and group_category_name == "Women's Fashion"):
        #             text = f"I am sorry but apparently we don't have {category.lower()} for {group_category_name}"
        #             dispatcher.utter_message(text=text)
        #             return {"group_category_name": None}
        #
        #     print(f"Group category name: {group_category_name}")
        #     return {"group_category_name": group_category_name}
        else:
            text = f"I am so sorry but currently our shop only has {len(group_category_names)} individual types of fashion:\n"

            for group_category_name in group_category_names:
                text += f"- {group_category_name}\n"
            dispatcher.utter_message(text=text)

            return {"group_category_name": None}

    def validate_category(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict,
    ) -> Dict[Text, Any]:

        categories = list_all_categories()
        category = slot_value
        group_category_name = tracker.get_slot("group_category_name")
        brand_name = tracker.get_slot("brand_name")
        type = tracker.get_slot("type")
        topic = tracker.get_slot("topic")

        if category:
            if group_category_name:
                categories = check_group_category_name_for_category(group_category_name=group_category_name, categories=categories)
            if brand_name:
                categories = check_brand_for_category(brand=brand_name, categories=categories)
            if type:
                categories = check_type_for_category(type=type, categories=categories)
            if topic:
                categories = check_topic_for_category(topic=topic, categories=categories)

            if category in categories:
                return {"category": category}
            else:
                text = "I am sorry but apparently for:\n"
                temp_list = [group_category_name, brand_name, type, topic]
                for item in temp_list:
                    if item is not None:
                        text += f"- {item}\n"

                text += f"Our shop does not have any: {category}."
                dispatcher.utter_message(text=text)
                return {"category": None}
        else:
            text = f"I am so sorry but currently our shop does not have this product category: {category}\n"
            dispatcher.utter_message(text=text)
            return {"category": None}

        # clothes = ["Shirt", "Pants"]
        # shoes = ["Shoes"]
        #
        # clothes_brands = ["H&M", "Gucci", "Zara"]
        # shoes_brands = ["Adidas", 'Nike']
        # brand_name = tracker.get_slot("brand_name")
        # if brand_name is not None:
        #     if (category in clothes and brand_name in clothes_brands) or (category in shoes and brand_name in shoes_brands):
        #         return {"category": category}
        #     else:
        #         text = f"I am sorry but for brand: {brand_name}, we don't have this product category: {category}."
        #         dispatcher.utter_message(text=text)
        #         return {"category": None}

        # if group_category_name:
        #     categories_based_on_group_category_name = list_categories_based_on_group_category_name(group_category_name)
        #     if category not in categories_based_on_group_category_name:
        #         text = f"I am sorry but our shop does not have {category} for {group_category_name}"
        #         dispatcher.utter_message(text=text)
        #         return {"category": None}
        #     else:
        #         return {"category": category}
        # else:
        #     # if category in clothes or category in shoes:
        #     #     print(f"category: {slot_value}")
        #     #     return {"category": slot_value}
        #     if category in all_categories:
        #         return {"category": category}
        #     else:
        #         text = f"I am so sorry but currently our shop does not have this product category: {category}\n"
        #         dispatcher.utter_message(text=text)
        #         return {"category": None}

    def validate_brand_name(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict,
    ) -> Dict[Text, Any]:

        # clothes = ["Shirt", "Pants"]
        # clothes_brands = ["H&M", "Zara", "Gucci"]
        #
        # shoes = ["shoes"]
        # shoes_brands = ["Nike", "Adidas"]
        #
        # category = tracker.get_slot("category")
        # brand = slot_value
        #
        # if category is not None:
        #     # Handle for clothes: shirt, pants
        #     if category.lower() in [p.lower() for p in clothes]:
        #         if brand in clothes_brands:
        #             print(f"Brand name: {brand}")
        #             return {"brand_name": brand}
        #         else:
        #             text = f"I am so sorry but currently our shop only has {len(clothes_brands)} brands for {category}:\n"
        #             for clothes_brand in clothes_brands:
        #                 text += f"- {clothes_brand.title()}\n"
        #             dispatcher.utter_message(text=text)
        #
        #             return {"brand_name": None}
        #     # Handle for shoes
        #     elif category.lower() in [p.lower() for p in shoes]:
        #         if brand in shoes_brands:
        #             return {"brand_name": brand}
        #         else:
        #             text = f"I am so sorry but currently our shop only has {len(shoes_brands)} brands for {category}:\n"
        #             for shoes_brand in shoes_brands:
        #                 text += f"- {shoes_brand.title()}\n"
        #             dispatcher.utter_message(text=text)
        #
        #             return {"brand_name": None}

        group_category_name = tracker.get_slot("group_category_name")
        category = tracker.get_slot("category")
        type = tracker.get_slot("type")
        topic = tracker.get_slot("topic")
        brands = list_all_brands()
        brand = slot_value

        if brand:
            if group_category_name:
                brands = check_group_category_for_brand(group_category_name=group_category_name, brands=brands)
            if category:
                brands = check_category_for_brand(category=category, brands=brands)
            if type:
                brands = check_type_for_brand(type=type, brands=brands)
            if topic:
                brands = check_topic_for_brand(topic=topic, brands=brands)

            if brand in brands:
                return {"brand_name": brand}
            else:
                text = "I am sorry but apparently for:\n"
                temp_list = [group_category_name, category, type, topic]

                for item in temp_list:
                    if item is not None:
                        text += f"- {item}\n"
                dispatcher.utter_message(text=text)
                return {"brand_name": None}
        else:
            text = f"I am sorry but currently our shop does not have this brand: {brand}"
            dispatcher.utter_message(text=text)
            return {"brand_name": None}

    def validate_knows_size(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict,
    ) -> Dict[Text, Any]:

        knows_size = tracker.get_slot("knows_size")

        if isinstance(knows_size, bool):
            return {"knows_size": knows_size}
        else:
            dispatcher.utter_message(text="I am sorry but I don't understand what you are saying can rephrase it please")
            return {"knows_size": None}

    def validate_clothes_size(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict,
    ) -> Dict[Text, Any]:

        clothes_size = slot_value
        category = tracker.get_slot("category")
        group_category_name = tracker.get_slot("group_category_name")
        size_template = []

        size_list = size_chart[group_category_name]['apparel']

        for size_info in size_list:
            size_template.append(size_info['size'])

        if clothes_size:
            if clothes_size in size_template:
                knows_size = tracker.get_slot("knows_material")
                if knows_size is None:
                    return {"clothes_size": clothes_size, "knows_size": True}

                return {"clothes_size": clothes_size}
            else:
                text = f"I see that you entered {clothes_size}, but for {group_category_name.lower()} our shop only has products for size:\n"
                for size in size_template:
                    text += f"- {size}\n"
                dispatcher.utter_message(text=text)
                return {"clothes_size": None}
        else:
            text = f"I am sorry but currently our shop only has {len(size_template)} sizes for {category}:\n"
            for size in size_template:
                text += f"- {size}\n"

            dispatcher.utter_message(text=text)
            return {"clothes_size": None}

    def validate_height(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict,
    ) -> Dict[Text, Any]:

        group_category_name = tracker.get_slot("group_category_name")
        height = slot_value

        if group_category_name:
            size_list = size_chart[group_category_name]['apparel']
        else:
            return {"group_category_name": None, "height": height, "knows_size": False}

        try:
            height = float(height)
            min_height = size_list[0]['height_min']
            max_height = size_list[len(size_list) - 1]['height_max']

            for size_info in size_list:
                if size_info['height_min'] <= height <= size_info['height_max']:
                    return {"height": height}
            else:
                text = ("I am sorry but it seems like you just entered an invalid height value.\n"
                        f"For {group_category_name}, our store only has size for height from {min_height}cm to {max_height}cm")
                dispatcher.utter_message(text=text)
                return {"height": None, "knows_size": False}
        except ValueError:
            dispatcher.utter_message(text="I am sorry but please enter height as a valid number")
            return {"height": None, "knows_size": False}

    def validate_weight(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict,
    ) -> Dict[Text, Any]:

        group_category_name = tracker.get_slot("group_category_name")
        weight = slot_value

        if group_category_name:
            size_list = size_chart[group_category_name]['apparel']
        else:
            return {"group_category_name": None, "weight": weight, "knows_size": False}

        try:
            weight = float(weight)
            min_weight = size_list[0]['weight_min']
            max_weight = size_list[len(size_list) - 1]['weight_max']

            for size_info in size_list:
                if size_info['weight_min'] <= weight <= size_info['weight_max']:
                    return {"weight": weight}
            else:
                text = ("I am sorry but it seems like you just entered an invalid weight value.\n"
                        f"For {group_category_name}, our store only has size for weight from {min_weight}kg to {max_weight}kg")
                dispatcher.utter_message(text=text)

                return {"weight": None, "knows_size": False}
        except ValueError:
            dispatcher.utter_message(text="I am sorry but please enter weight as a valid number")
            return {"weight": None, "knows_size": False}

    def validate_shoes_size(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict,
    ) -> Dict[Text, Any]:

        shoes_size = slot_value

        if shoes_size:
            try:
                shoes_size = float(shoes_size)
            except ValueError:
                text = "I am sorry but please enter shoes size as a valid number"
                dispatcher.utter_message(text=text)
                return {"shoes_size": None}

            group_category_name = tracker.get_slot("group_category_name")
            size_list = size_chart[group_category_name]['shoes']
            size_template = []

            for size_info in size_list:
                size_template.append(size_info['size'])

            if shoes_size in size_template:
                knows_size = tracker.get_slot("knows_size")
                if knows_size is None:
                    return {"shoes_size": shoes_size, "knows_size": True}

                return {"shoes_size": shoes_size}
            else:
                text = f"I see that you entered {shoes_size}, but for {group_category_name.lower()} our shop only has shoes for size:\n"
                for size in size_template:
                    text += f"- {size}\n"
                dispatcher.utter_message(text=text)
                return {"shoes_size": None}
        else:
            text = "I am sorry but I don't understand your shoes size."
            dispatcher.utter_message(text=text)
            return {"shoes_size": None}

    def validate_knows_foot_length(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict,
    ) -> Dict[Text, Any]:

        knows_foot_length = tracker.get_slot("knows_foot_length")

        if isinstance(knows_foot_length, bool):
            if knows_foot_length:
                text = "Great!"
            else:
                text = (f"If you don't know how to measure your foot length, it's ok because I am here to help you.\n"
                        f"Here are the steps that can help you measure your foot length:\n"
                        f"- Step 1: Prepare a sheet of paper, larger than your foot, a pencil, and a ruler.\n"
                        f"- Step 2: Put the sheet of paper on the floor, stand tall and put your foot on it. Use your pencil to draw your foot.\n"
                        f"- Step 3: Use your ruler to measure the length from the heel to the tip of longest toe, which you have drawn on the paper. That will be your length of foot.\n")

            dispatcher.utter_message(text=text)
            return {"knows_foot_length":  knows_foot_length}
        else:
            dispatcher.utter_message(text="I am sorry but I don't under what you are trying to say, can you rephrase it please")
            return {"knows_foot_length": None}


    def validate_foot_length(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict,
    ) -> Dict[Text, Any]:

        group_category_name = tracker.get_slot("group_category_name")
        foot_length = slot_value

        if group_category_name:
            size_list = size_chart[group_category_name]['shoes']
        else:
            return {"group_category_name": None, "foot_length": foot_length, "knows_size": False, "knows_foot_length": True}

        try:
            foot_length = float(foot_length)
            min_foot_length = size_list[0]["foot_length_min"]
            max_foot_length = size_list[len(size_list) - 1]["foot_length_max"]

            for size_info in size_list:
                if size_info['foot_length_min'] <= foot_length <= size_info['foot_length_max']:
                    knows_foot_length = tracker.get_slot("knows_foot_length")
                    if knows_foot_length is None:
                        return {"foot_length": foot_length, "knows_foot_length": True}

                    return {"foot_length": foot_length}
            else:
                text = ("I am sorry but it seems like you just entered an invalid foot length value.\n"
                        f"For {group_category_name}, our store only has size for foot length from {min_foot_length}cm to {max_foot_length}cm")
                dispatcher.utter_message(text=text)
                return {"foot_length": None, "knows_size": False, "knows_foot_length": True}
        except ValueError:
            dispatcher.utter_message(text="I am sorry but please enter foot length as a valid number")
            return {"foot_length": None, "knows_size": False, "knows_foot_length": True}

class ActionResetSlots(Action):
    def name(self) -> Text:
        return "action_reset_slots"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        return [Restarted()]

class ActionAskPromotionType(Action):
    def name(self) -> Text:
        return "action_ask_promotion_type"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        promotion_types = ["Order", "Delivery", "Both"]
        text = "What type of promotions that you are looking for?"
        buttons = []

        for promotion_type in promotion_types:
            if promotion_type == "Both":
                button = {
                    "title": f"{promotion_type}",
                    "payload": f"Order and Delivery",
                }
            else:
                button = {
                    "title": f"{promotion_type}",
                    "payload": f"{promotion_type}"
                }
            buttons.append(button)

        dispatcher.utter_message(text=text, buttons=buttons)
        return []

class ValidatePromotionForm(FormValidationAction):
    def name(self) -> Text:
        return "validate_promotion_form"

    async def required_slots(
        self,
        domain_slots: List[Text],
        dispatcher: "CollectingDispatcher",
        tracker: "Tracker",
        domain: "DomainDict",
    ) -> List[Text]:

        updated_slots = domain_slots.copy()

        knows_order_price = tracker.get_slot("knows_order_price")
        price = tracker.get_slot("price")

        if knows_order_price is not None:
            if knows_order_price == False:
                updated_slots.remove("price")

        # if price is not None and knows_order_price is None:
        #     updated_slots.remove("knows_order_price")

        return updated_slots

    def validate_promotion_type(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict,
    ) -> Dict[Text, Any]:

        promotion_types = list_all_promotion_types()
        promotion_type = slot_value
        # promotion_type_amount = tracker.get_slot("promotion_type_amount")
        # price = tracker.get_slot("price")
        # price_description = tracker.get_slot("price_description")

        # promotion_type = slot_value
        # single_promotion_type = ["Order", "Delivery"]
        # both_promotion_type = ["Both", "All", "Order and Delivery", "Delivery and Order"]
        # single_type_str = set()
        # single_type_count = 0
        # both_types_count = 0

        # if promotion_type in promotion_types:
        #     return {"promotion_type": promotion_type}
        # else:
        #     text = f"I am sorry but I cannot understand this type of promotion: {promotion_type}"
        #     dispatcher.utter_message(text=text)
        #     return {"promotion_type": None}

        # if promotion_type:
        #     # Chatbot detects 1 entity
        #     if len(promotion_type) == 1:
        #         for t in single_promotion_type:
        #             if t.lower() in promotion_type[0].lower():
        #                 return {"promotion_type": [t]}
        #
        #         for t in both_promotion_type:
        #             if t.lower() in promotion_type[0].lower():
        #                 return {"promotion_type": [both_promotion_type[2]]}
        #     # Chatbot detects 2 entities
        #     else:
        #         for pt in promotion_type:
        #             for t in single_promotion_type:
        #                 if t.lower() in pt.lower():
        #                     single_type_count += 1
        #                     single_type_str.add(t)
        #
        #             for t in both_promotion_type:
        #                 if t.lower() in pt.lower():
        #                     both_types_count += 1
        #         # Two entities appear: Order and Delivery
        #         if single_type_count == 2 and len(single_type_str) == 2:
        #             return {"promotion_type": [both_promotion_type[2]]}
        #         # One entity appears twice: Order or Delivery
        #         elif single_type_count == 2 and len(single_type_str) == 1:
        #             return {"promotion_type": list(single_type_str)}
        #         # One entity appears once: Order, Delivery or Both, All
        #         elif single_type_count == 1 or both_types_count == 1:
        #             return {"promotion_type": list(single_type_str)}
        #         elif both_types_count == 2:
        #             print("Both types check here")
        #             return {"promotion_type": [both_promotion_type[2]]}

        if promotion_type:
            for pt in promotion_type:
                if pt not in promotion_types:
                    text = f"I am sorry but there is no promotions with type: {pt}"
                    dispatcher.utter_message(text=text)
                    return {"promotion_type": None}

            promotion_type = list(set(promotion_type))

            if len(promotion_type) == 2:
                return {"promotion_type": promotion_type, "promotion_type_amount": "Both"}
            else:
                return {"promotion_type": promotion_type, "promotion_type_amount": "One"}

        else:
            text = "I am sorry but apparently I don't understand the type of promotion that you want, can you rephrease it please."
            dispatcher.utter_message(text=text)
            return {"promotion_type": None}

    def validate_promotion_type_amount(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict,
    ) -> Dict[Text, Any]:

        promotion_type = tracker.get_slot("promotion_type")
        promotion_type_template = list_all_promotion_types()
        promotion_type_amount = slot_value

        if promotion_type_amount and promotion_type is None:
            return {"promotion_type_amount": promotion_type_amount, "promotion_type": promotion_type_template}

    def validate_knows_order_price(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict,
    ) -> Dict[Text, Any]:

        knows_order_price = slot_value
        print("Reached knows order price in promotion form")

        if isinstance(knows_order_price, bool):
            print(f"Knows order price: {knows_order_price}")
            return {"knows_order_price": knows_order_price}

        text = "I am sorry but I don't get what you mean, can you rephrease it please"
        dispatcher.utter_message(text=text)
        return {"knows_order_price": None}

    def validate_price(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict,
    ) -> Dict[Text, Any]:

        price = slot_value
        new_price = []

        print("Reached price here in promotion form")

        if price:
            for item in price:
                try:
                    new_price.append(float(item))
                except ValueError:
                    text = "I am sorry but I don't understand the range of price you provided."
                    dispatcher.utter_message(text=text)
                    return {"price": None}

            knows_order_price = tracker.get_slot("knows_order_price")
            if knows_order_price is None:
                return {"price": new_price, "knows_order_price": True}

            return {"price": new_price}
        else:
            text = "I am sorry but I don't understand this price."
            dispatcher.utter_message(text=text)
            return {"price": None}

# class ActionSetPromotionPrice(Action):
#     def name(self) -> Text:
#         return "action_set_promotion_price"
#
#     def run(
#         self,
#         dispatcher: "CollectingDispatcher",
#         tracker: Tracker,
#         domain: "DomainDict",
#     ) -> List[Dict[Text, Any]]:
#
#         price = tracker.get_slot("price")
#
#         if price:
#             return [SlotSet("price", price)]
#
#         return []
#
# class ActionSetPromotionType(Action):
#     def name(self) -> Text:
#         return "action_set_promotion_type"
#
#     def run(
#         self,
#         dispatcher: "CollectingDispatcher",
#         tracker: Tracker,
#         domain: "DomainDict",
#     ) -> List[Dict[Text, Any]]:
#
#         promotion_type = tracker.get_slot("promotion_type")
#
#         if promotion_type:
#             if len(promotion_type) == 2:
#                 return [SlotSet("promotion_type", ["Order", "Delivery"]),
#                         SlotSet("promotion_type_amount", "Both")]
#             elif len(promotion_type) == 1:
#                 if "Order" in promotion_type:
#                     return [SlotSet("promotion_type", ["Order"]),
#                             SlotSet("promotion_type_amount", "One")]
#                 elif "Delivery" in promotion_type:
#                     return [SlotSet("promotion_type", ["Order"]),
#                             SlotSet("promotion_type_amount", "One")]
#
#         return []

def list_all_promotions():
    query = """
            SELECT price_limit, max_discount, description
            FROM promotions
            """

    result = DatabaseManager.execute_query(query=query, params=None)
    return result

def list_all_promotions_with_type(type, current_date):
    if len(type) == 2:
        print("Reached 2 types of promotion without price")
        query = """
                SELECT price_limit, max_discount, description
                FROM promotions
                WHERE status = "active" AND %s BETWEEN start_date AND end_date AND quantity_in_stock > 0
                """
    else:
        if "Order" in type:
            query = """
                    SELECT price_limit, max_discount, description
                    FROM promotions
                    WHERE type = "order_discount" AND status = "active" AND %s BETWEEN start_date AND end_date AND quantity_in_stock > 0
                    """
        else:
            query = """
                    SELECT price_limit, max_discount, description
                    FROM promotions
                    WHERE type = "shipping_discount" AND status = "active" AND %s BETWEEN start_date AND end_date AND quantity_in_stock > 0
                    """

    result = DatabaseManager.execute_query(query=query, params=(current_date,))
    return result

def list_all_promotions_with_type_and_price(type, price, price_description, current_date):
    if len(price) == 2:
        if len(type) == 2:
            if price_description:
                if "Under" in price_description:
                    query = """
                            SELECT price_limit, max_discount, description
                            FROM promotions
                            WHERE price_limit < %s AND status = "active" AND %s BETWEEN start_date AND end_date AND quantity_in_stock > 0
                            """
                else:
                    query = """
                            SELECT price_limit, max_discount, description
                            FROM promotions
                            WHERE price_limit <= %s AND status = "active" AND %s BETWEEN start_date AND end_date AND quantity_in_stock > 0
                            """
            else:
                query = """
                        SELECT price_limit, max_discount, description
                        FROM promotions
                        WHERE price_limit <= %s AND status = "active" AND %s BETWEEN start_date AND end_date AND quantity_in_stock > 0
                        """
        else:
            if "Order" in type:
                if price_description:
                    if "Under" in price_description:
                        query = """
                                SELECT price_limit, max_discount, description
                                FROM promotions
                                WHERE price_limit < %s AND type = "order_discount" AND status = "active" AND %s BETWEEN start_date AND end_date AND quantity_in_stock > 0
                                """
                    else:
                        query = """
                                SELECT price_limit, max_discount, description
                                FROM promotions
                                WHERE price_limit <= %s AND type = "order_discount" AND status = "active" AND %s BETWEEN start_date AND end_date AND quantity_in_stock > 0
                                """
                else:
                    query = """
                            SELECT price_limit, max_discount, description
                            FROM promotions
                            WHERE price_limit <= %s AND type = "order_discount" AND status = "active" AND %s BETWEEN start_date AND end_date AND quantity_in_stock > 0
                            """
            else:
                if price_description:
                    if "Under" in price_description:
                        query = """
                                SELECT price_limit, max_discount, description
                                FROM promotions
                                WHERE price_limit < %s AND type = "shipping_discount" AND status = "active" AND %s BETWEEN start_date AND end_date AND quantity_in_stock > 0
                                """
                    else:
                        query = """
                                SELECT price_limit, max_discount, description
                                FROM promotions
                                WHERE price_limit <= %s AND type = "shipping_discount" AND status = "active" AND %s BETWEEN start_date AND end_date AND quantity_in_stock > 0
                                """
                else:
                    query = """
                            SELECT price_limit, max_discount, description
                            FROM promotions
                            WHERE price_limit <= %s AND type = "shipping_discount" AND status = "active" AND %s BETWEEN start_date AND end_date AND quantity_in_stock > 0
                            """

        result = DatabaseManager.execute_query(query=query, params=(price[1],current_date))
        return result

    else:
        if price_description:
            print("Reached price description")
            if ("Under" in price_description and "Equal" in price_description) or "Above" in price_description or "Equal" in price_description:
                if len(type) == 2:
                    query = """
                            SELECT price_limit, max_discount, description
                            FROM promotions
                            WHERE price_limit <= %s AND status = "active" AND %s BETWEEN start_date AND end_date AND quantity_in_stock > 0
                            """
                else:
                    if "Order" in type:
                        query = """
                                SELECT price_limit, max_discount, description
                                FROM promotions
                                WHERE price_limit <= %s AND type = "order_discount" AND status = "active" AND %s BETWEEN start_date AND end_date AND quantity_in_stock > 0
                                """
                    else:
                        query = """
                                SELECT price_limit, max_discount, description
                                FROM promotions
                                WHERE price_limit <= %s AND type = "shipping_discount" AND status = "active" AND %s BETWEEN start_date AND end_date AND quantity_in_stock > 0
                                """
            elif "Under" in price_description:
                if len(type) == 2:
                    query = """
                            SELECT price_limit, max_discount, description
                            FROM promotions
                            WHERE price_limit < %s AND status = "active" AND %s BETWEEN start_date AND end_date AND quantity_in_stock > 0
                            """
                else:
                    if "Order" in type:
                        query = """
                                SELECT price_limit, max_discount, description
                                FROM promotions
                                WHERE price_limit < %s AND type = "order_discount" AND status = "active" AND %s BETWEEN start_date AND end_date AND quantity_in_stock > 0
                                """
                    else:
                        query = """
                                SELECT price_limit, max_discount, description
                                FROM promotions
                                WHERE price_limit < %s AND type = "shipping_discount" AND status = "active" AND %s BETWEEN start_date AND end_date AND quantity_in_stock > 0
                                """
            else:
                query = """
                        SELECT price_limit, max_discount, description
                        FROM promotions
                        WHERE price_limit <= %s AND status = "active" AND %s BETWEEN start_date AND end_date AND quantity_in_stock > 0
                        """
        else:
            if len(type) == 2:
                query = """
                        SELECT price_limit, max_discount, description
                        FROM promotions
                        WHERE price_limit <= %s AND status = "active" AND %s BETWEEN start_date AND end_date AND quantity_in_stock > 0
                        """
            else:
                if "Order" in type:
                    query = """
                            SELECT price_limit, max_discount, description
                            FROM promotions
                            WHERE price_limit <= %s AND type = "order_discount" AND status = "active" AND %s BETWEEN start_date AND end_date AND quantity_in_stock > 0
                            """
                else:
                    query = """
                            SELECT price_limit, max_discount, description
                            FROM promotions
                            WHERE price_limit <= %s AND type = "shipping_discount" AND status = "active" AND %s BETWEEN start_date AND end_date AND quantity_in_stock > 0
                            """

    result = DatabaseManager.execute_query(query=query, params=(price[0], current_date))
    return  result

def list_promotions(type, price, price_description):
    # if type is None and price is None:
    #     promotions = list_all_promotions()

    print(f"Type: {type}, price: {price}")

    current_date = datetime.date.today()
    current_date = current_date.strftime("%Y-%m-%d")

    if type and price is None:
        promotions = list_all_promotions_with_type(type, current_date)
    elif type and price:
        print("Reached type and price here")
        promotions = list_all_promotions_with_type_and_price(type, price, price_description, current_date)

    return promotions

class ActionGeneratePromotions(Action):
    def name(self) -> Text:
        return "action_generate_promotions"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        promotion_type = list(set(tracker.get_slot("promotion_type")))
        price = tracker.get_slot("price")

        price_description = tracker.get_slot("price_description")

        if price:
            price = sorted(list(set(price)))

            promotions = list_promotions(type=promotion_type, price=price, price_description=price_description)
            print("Reached price here")

        else:
            promotions = list_promotions(type=promotion_type, price=None, price_description=None)

        if len(promotions) == 0:
            text = "I am sorry but I cannot find any promotions with your provided information."

            formatted_text = format_generated_answer(text)
            dispatcher.utter_message(formatted_text)

            # dispatcher.utter_message(text=text)
            return [Restarted()]

        text = "I have found some promotions based on your provided information:\n"

        for row in promotions:
            text += f"{row['description']} for order's price from {row['price_limit']} with {row['max_discount']}$ max discount.\n"

        formatted_text = format_generated_answer(text)
        dispatcher.utter_message(formatted_text)
        # dispatcher.utter_message(text=text)
        return [Restarted()]

class ActionAskRecommendationInformation(Action):
    def name(self) -> Text:
        return "action_ask_recommendation_information"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        text = ("Don't worry our valuable guest, I am here to help you.\n"
                "What product are you looking for to buy, recommend, or search?\n"
                "It would be great if you can provide me more information about the product you are looking for, for example:\n"
                "- Group category name\n"
                "- Product category\n"
                "- Product type\n"
                "- Topic\n"
                "- Price range")

        dispatcher.utter_message(text=text)
        return []

class ActionAskType(Action):
    def name(self) -> Text:
        return "action_ask_type"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        # Based on the category set previously to ask for product type

        category = tracker.get_slot("category")

        text = (f"Since I know that you are looking for {category}\n"
                "But can you tell more about the specific product?")

        for item in text.split('\n'):
            dispatcher.utter_message(text=item)

        return []

class ActionAskKnowsMaterial(Action):
    def name(self) -> Text:
        return "action_ask_knows_material"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        text = "Do you know the type of material of your product?"
        buttons = [
            {
                "title": "I do know the material",
                "payload": "Yes"
            },

            {
                "title": "I don't know the material",
                "payload": "No"
            }
        ]

        dispatcher.utter_message(text=text, buttons=buttons)
        return []

class ActionAskMaterial(Action):
    def name(self) -> Text:
        return "action_ask_material"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        text = "What type of material that you want your product to be made of"
        dispatcher.utter_message(text=text)
        return []

class ActionAskTopic(Action):
    def name(self) -> Text:
        return "action_ask_topic"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        text = "Can you tell me the style that you are looking for?"
        dispatcher.utter_message(text=text)
        return []

class ActionAskPrice(Action):
    def name(self) -> Text:
        return "action_ask_price"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        text = "Can you tell me about the price range?"
        dispatcher.utter_message(text=text)
        return []

class ActionAskKnowsOrderPrice(Action):
    def name(self) -> Text:
        return "action_ask_knows_order_price"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        text = "Do you know about your order's total price so that I can help you find more suitable promotions for you."
        buttons = [
            {
                "title": "Yes, I know my order's price",
                "payload": "Yes"
            },

            {
                "title": "No, I don't know",
                "payload": "No"
            }
        ]

        dispatcher.utter_message(text=text, buttons=buttons)
        return []

class ValidateProductRecommendationForm(FormValidationAction):
    def name(self) -> Text:
        return "validate_product_recommendation_form"

    def create_entity_dict(self, slots, tracker):
        entity_dict = {}

        for slot in slots:
            if slot == "knows_material":
                continue
            else:
                slot_value = tracker.get_slot(slot)
                if slot_value is not None:
                    entity_dict[slot] = slot_value

        return entity_dict

    async def required_slots(
        self,
        domain_slots: List[Text],
        dispatcher: "CollectingDispatcher",
        tracker: "Tracker",
        domain: "DomainDict",
    ) -> List[Text]:

        updated_slots = domain_slots.copy()

        category = tracker.get_slot("category")
        type = tracker.get_slot("type")

        knows_material = tracker.get_slot("knows_material")
        noun = tracker.get_slot("noun")
        adjective= tracker.get_slot("adjective")

        self.entity_dict = self.create_entity_dict(domain_slots.copy(), tracker)

        # if type is not None and category is None:
        #     updated_slots.remove("category")

        if knows_material is not None:
            if not knows_material:
                updated_slots.remove("material")
                # print("Don't know materials")
            # else:
            #     print("Knows materials")

        # if noun or adjective:
        #     print(f"Noun description: {noun}")
        #     print(f"Adjective description: {adjective}")

        return updated_slots

    def validate_group_category_name(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict,
    ) -> Dict[Text, Any]:

        group_category_names = list_all_group_categories_name()
        group_category_name = slot_value
        category = tracker.get_slot("category")
        brand_name = tracker.get_slot("brand_name")
        type = tracker.get_slot("type")
        topic = tracker.get_slot("topic")

        if group_category_name:
            if category:
                group_category_names = check_category_for_group_category_name(category=category, group_category_names=group_category_names)

            if brand_name:
                group_category_names = check_brand_for_group_category_name(brand=brand_name, group_category_names=group_category_names)

            if type:
                group_category_names = check_type_for_group_category_name(type=type, group_category_names=group_category_names)

            if topic:
                group_category_names = check_topic_for_group_category_name(topic=topic, group_category_names=group_category_names)

            if group_category_name in group_category_names:
                return {"group_category_name": group_category_name}
            else:
                text = "I am sorry but apparently for:\n"
                temp_list = [category, brand_name, type, topic]

                for item in temp_list:
                    if item is not None:
                        text += f"- {item}\n"
                text += f"We don't have: {group_category_name}"
                dispatcher.utter_message(text=text)
                return {"group_category_name": None}
        else:
            text = "I am sorry but I don't understand this group of category name."
            dispatcher.utter_message(text=text)
            return {"group_category_name": None}

    def validate_category(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict,
    ) -> Dict[Text, Any]:

        categories = list_all_categories()
        category = slot_value
        group_category_name = tracker.get_slot("group_category_name")
        brand_name = tracker.get_slot("brand_name")
        type = tracker.get_slot("type")
        topic = tracker.get_slot("topic")

        if category:
            if group_category_name:
                categories = check_group_category_name_for_category(group_category_name=group_category_name, categories=categories)
            if brand_name:
                categories = check_brand_for_category(brand=brand_name, categories=categories)
            if type:
                categories = check_type_for_category(type=type, categories=categories)
            if topic:
                categories = check_topic_for_category(topic=topic, categories=categories)

            if category in categories:
                return {"category": category}
            else:
                text = "I am sorry but apparently for:\n"
                temp_list = [group_category_name, brand_name, type, topic]
                for item in temp_list:
                    if item is not None:
                        text += f"- {item}\n"

                text += f"Our shop does not have any: {category}."
                dispatcher.utter_message(text=text)
                return {"category": None}
        else:
            text = "I am sorry but I don't understand this category."
            dispatcher.utter_message(text=text)
            return {"category": None}

    def validate_type(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict,
    ) -> Dict[Text, Any]:

        type = slot_value
        all_types = list_all_product_types()

        if type:
            if type in all_types:
                category = tracker.get_slot("category")
                if category is None:
                    category = find_category_base_on_type(type=type)
                    return {"type": type, "category": category}
                else:
                    category_check = find_category_base_on_type(type=type)
                    if category != category_check:
                        text = f"I am sorry but for {category}, I can't find any: {type}"
                        dispatcher.utter_message(text=text)
                        return {"type": None, "category": category}

                return {"type": type}
            else:
                text = f"I am sorry but apparently, our shop does not have this type of product: {type}"
                dispatcher.utter_message(text=text)
                return {"type": None}
        else:
            text = "I am sorry but I don't understand this type."
            dispatcher.utter_message(text=text)
            return {"type": None}

    # def validate_knows_material(
    #         self,
    #         slot_value: Any,
    #         dispatcher: CollectingDispatcher,
    #         tracker: Tracker,
    #         domain: DomainDict,
    # ) -> Dict[Text, Any]:
    #
    #     knows_material = slot_value
    #
    #     if isinstance(knows_material, bool):
    #         return {"knows_material": knows_material}
    #     else:
    #         text = "I am sorry but I don't get what you mean, can you rephrase it please?"
    #         dispatcher.utter_message(text=text)
    #         return {"knows_material": None}
    #
    # def validate_material(
    #         self,
    #         slot_value: Any,
    #         dispatcher: CollectingDispatcher,
    #         tracker: Tracker,
    #         domain: DomainDict,
    # ) -> Dict[Text, Any]:
    #
    #     material = slot_value
    #     all_materials = list_all_materials()
    #
    #
    #     if material:
    #         for item in material:
    #             if item not in all_materials:
    #                 text = f"I am sorry but our shop does not any products with this type of material: {material}"
    #                 dispatcher.utter_message(text=text)
    #                 return {"material": None}
    #
    #         return {"material": material}
    #     else:
    #         text = "I am sorry but I don't understand this material"
    #         dispatcher.utter_message(text=text)
    #         return {"material": None}

    def validate_topic(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict,
    ) -> Dict[Text, Any]:

        topic = slot_value
        all_topics = list_all_topics()
        print(f"All topics: {all_topics}")

        if topic:
            valid_topic = []
            contain_valid_topics = False

            for item in topic:
                if item not in all_topics:
                    continue
                else:
                    valid_topic.append(item)
                    contain_valid_topics = True

            if contain_valid_topics:
                return {"topic": valid_topic}
            else:
                text = "I am sorry but apparently I cannot find the any data relates to your style"
                dispatcher.utter_message(text=text)
                return {"topic": None}

        else:
            text = "I am sorry but I don't understand this topic."
            dispatcher.utter_message(text=text)
            return {"topic": None}

    def validate_brand_name(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict,
    ) -> Dict[Text, Any]:

        group_category_name = tracker.get_slot("group_category_name")
        category = tracker.get_slot("category")
        type = tracker.get_slot("type")
        topic = tracker.get_slot("topic")
        brands = list_all_brands()
        brand = slot_value

        if brand:
            if group_category_name:
                brands = check_group_category_for_brand(group_category_name=group_category_name, brands=brands)
            if category:
                brands = check_category_for_brand(category=category, brands=brands)
            if type:
                brands = check_type_for_brand(type=type, brands=brands)
            if topic:
                brands = check_topic_for_brand(topic=topic, brands=brands)

            if brand in brands:
                return {"brand_name": brand}
            else:
                text = "I am sorry but apparently for:\n"
                temp_list = [group_category_name, category, type, topic]

                for item in temp_list:
                    if item is not None:
                        text += f"- {item}\n"
                dispatcher.utter_message(text=text)
                return {"brand_name": None}
        else:
            text = "I am sorry but I don't understand this brand's name."
            dispatcher.utter_message(text=text)
            return {"brand_name": None}

    def validate_price(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict,
    ) -> Dict[Text, Any]:

        price = slot_value
        print("Reached price here")

        if price:
            return {"price": price}
        else:
            text = "I am sorry but I don't understand this price."
            dispatcher.utter_message(text=text)
            return {"price": None}

class ActionGenerateProductRecommendation(Action):
    def name(self) -> Text:
        return "action_generate_product_recommendation"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        group_category_name = tracker.get_slot("group_category_name")
        category = tracker.get_slot("category")
        type = tracker.get_slot("type")
        topic = tracker.get_slot("topic")
        brand_name = tracker.get_slot("brand_name")
        price = tracker.get_slot("price")

        # Price range
        if len(price) > 1:
            price = sorted(price)
            price_start = price[0]
            price_end = price[1]
            price_description = "between"

            params = (group_category_name, category, type, topic[0], brand_name, price_start, price_description, price_end)

        else:
            price_description = tracker.get_slot("price_description")
            price_start = price[0]
            price_end = None

            if price_description:
                price_description_param = None

                for description in price_description:
                    if description == "Equal" or description == "Under" or description == "Above":
                        price_description_param = description.lower()

                params = (group_category_name, category, type, topic[0], brand_name, price_start, price_description_param, price_end)
            else:
                price_description_param = "equal"
                params = (group_category_name, category, type, topic[0], brand_name, price_start, price_description_param, price_end)

        result = DatabaseManager.call_stored_procedure("get_recommended_products", params=params)
        print(result)

        if len(result) == 0:
            text = "I am sorry, but apparently I cannot find any products with your provided information"

            # dispatcher.utter_message(text=text)
            # return []
        else:
            text = "Here are the results that I have found with your provided information:\n"

            for idx, product in enumerate(result):
                if idx == len(result) - 1:
                    text += f"{idx + 1}. {product['name']} of {product['brand']} with price: {product['price']}$"
                else:
                    text += f"{idx + 1}. {product['name']} of {product['brand']} with price: {product['price']}$\n"

        # if knows_material:
        #     material = tracker.get_slot("material")
        #     price_description = tracker.get_slot("price_description")
        #     """Call SP to get product with material"""
        #
        #     # text = ("Generate product recommendation with provided information:\n"
        #     #         f"- Group category name: {group_category_name}\n"
        #     #         f"- Category: {category}\n"
        #     #         f"- Type: {type}\n"
        #     #         f"- Material: {material}\n"
        #     #         f"- Topic: {topic}\n"
        #     #         f"- Brand name: {brand_name}\n"
        #     #         f"- Price: {price}")
        #     params = (group_category_name, category, type, topic, brand_name, price)
        #     if price_description:
        #         params = (group_category_name, category, type, topic, brand_name, price, price_description)
        #     else:
        #
        #
        # else:
        #     price_description = tracker.get_slot("price_description")
        #
        #
        #     """Call SP to get product without material"""
        #     text = ("Generate product recommendation with provided information:\n"
        #             f"- Group category name: {group_category_name}\n"
        #             f"- Category: {category}\n"
        #             f"- Type: {type}\n"
        #             f"- Material: No material\n"
        #             f"- Topic: {topic}\n"
        #             f"- Brand name: {brand_name}\n"
        #             f"- Price: {price}")

        formatted_text = format_generated_answer(text)
        dispatcher.utter_message(formatted_text)

        for message in formatted_text.split("\n"):
            dispatcher.utter_message(text=message)

        # for message in text.split("\n"):
        #     dispatcher.utter_message(text=message)
        return [Restarted()]

class ActionGuideTrackingOrderStatus(Action):
    def name(self) -> Text:
        return "action_guide_tracking_order_status"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        text = "Don't worry, I am here to help you check the status of your orders.\n"
        dispatcher.utter_message(text=text)

        text = ("Here are the steps that you can follow to track your orders' status:\n"
                "- Go to your order history\n"
                "- You will see a list of your orders there\n"
                "- In that list you will also see the status of your orders\n"
                "- Or if you want to see more details about your orders\n"
                "- Just click the Detail button at the corresponding order and you are good to go")

        for message in text.split("\n"):
            dispatcher.utter_message(text=message)

        return [Restarted()]

class ActionGuideRefundProducts(Action):
    def name(self) -> Text:
        return "action_guide_refund_products"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        text = ("I am so sorry for your inconvenience but don't worry I am here to help you.\n"
                "Here are the steps that can help you to make a refund:\n"
                "Step 1: Click to your order history.\n"
                "Step 2: Find the order that you want to return.\n"
                "Step 3: Click on the Detail button of the corresponding order.\n"
                "Step 4: Scroll down and you will see the Return button.\n"
                "Step 5: Click on it and you are good to go.\n"
                "Please note that there will be staff contacting you to ask for the reason why you want to make a refund, please remeber to pick up the phone. Thank you")

        for message in text.split("\n"):
            dispatcher.utter_message(text=message)

        return [Restarted()]

class ActionInformRestart(Action):
    def name(self) -> Text:
        return "action_inform_restart"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        text = "I have reset everything for you. What can I do for you?"
        buttons = [
            {
                "title": "I am looking for promotions",
                "payload": "promotions"
            },

            {
                "title": "Recommend for me products",
                "payload": "product recommendation"
            },

            {
                "title": "I need help choosing size",
                "payload": "help with size"
            },

            {
                "title": "Check orders' status",
                "payload": "order status tracking"
            },

            {
                "title": "Make refunds",
                "payload": "I want to make a refund"
            },

            # {
            #     "title": "Show new products",
            #     "payload": "new products"
            # },
        ]

        dispatcher.utter_message(text=text, buttons=buttons)
        return []

class ActionAnswerOpenTime(Action):
    def name(self) -> Text:
        return "action_answer_open_time"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        text = "Our shop opens at 8 a.m"
        dispatcher.utter_message(text=text)

        return []

class ActionAnswerCloseTime(Action):
    def name(self) -> Text:
        return "action_answer_close_time"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        text = "Our shop closes at 9 p.m"
        dispatcher.utter_message(text=text)

        return []

class ActionHandleOutOfScope(Action):
    def name(self) -> Text:
        return "action_handle_out_of_scope"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        text = "I am sorry but I don't get what you mean."
        dispatcher.utter_message(text=text)
        return []

class ActionDefaultFallback(Action):
    def name(self) -> Text:
        return "action_default_fallback"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        dispatcher.utter_message(text="Apparently there is something wrong.\n")
        return [Restarted(), FollowupAction("action_inform_restart")]