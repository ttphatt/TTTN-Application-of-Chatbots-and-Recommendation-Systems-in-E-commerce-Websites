# This files contains your custom actions which can be used to run
# custom Python code.
#
# See this guide on how to implement these action:
# https://rasa.com/docs/rasa-pro/concepts/custom-actions
import google.generativeai as genai
from datetime import datetime, timedelta
import random
import mysql.connector
from mysql.connector import Error
import logging
from contextlib import contextmanager
import os
# This is a simple example for a custom action which utters "Hello World!"

from typing import Any, Text, Dict, List

from rasa_sdk import Action, Tracker, FormValidationAction
from rasa_sdk.events import AllSlotsReset, ActionExecuted, FollowupAction, ActiveLoop, EventType, Restarted, SlotSet
from rasa_sdk.executor import CollectingDispatcher
from rasa_sdk.types import DomainDict
import re


#############################################################
def list_all_categories():
    query = """
        SELECT name
        FROM categories
        WHERE parent_id < 2
    """

    result_dict = DatabaseManager.execute_query(query=query, params=None)
    categories = []

    for item in result_dict:
        categories.append(item['name'])

    return categories

def count_all_product_type_id():
    query =  """
        SELECT COUNT(id) as total_id
        FROM product_variants
    """

    result = DatabaseManager.execute_query(query, None)
    count = result[0]['total_id']

    return count
#############################################################

#
#
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

# Free API key
# genai.configure(api_key="AIzaSyCjMOlYTEY0IvVsenAuxuRcG8M5oho5Trc")

# Pro API key
genai.configure(api_key="AIzaSyAjumb0lhR8Qlr2GVcjqB27z8PxpBCj74s")

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

class ActionGreetCustom(Action):
    def name(self) -> Text:
        return "action_greet_custom"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:


        text = ("Hi there, welcome to admin section of the shop. I am your virtual assistant, Rasa, how can I help you?")
        buttons = [
            {
                "title": "I want to see report of shopping trends",
                "payload": "shopping trends"
            },

            {
                "title": "I want to see revenue report",
                "payload": "revenue report"
            },

            {
                "title": "I want to see profits report",
                "payload": "profits report"
            }
        ]

        print("Lattest message: ", tracker.latest_message['text'])
        dispatcher.utter_message(text=text, buttons=buttons)
        return []

class ActionAskGemini(Action):
    def name(self) -> Text:
        return "action_ask_gemini"

    def call_llm_model(prompt):
        llm_model = genai.GenerativeModel(
            model_name="gemini-2.5-flash-pro",
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

class ActionGenerateTrendReport(Action):
    def name(self) -> Text:
        return "action_generate_trend_report"

    def converse_trend_analysis_type(self, trend_analysis_type):
        if trend_analysis_type == "Best Seller":
            trend_analysis_type_param = "most_purchased"
        elif trend_analysis_type == "Least Seller":
            trend_analysis_type_param = "least_purchased"
        elif trend_analysis_type == "Most View":
            trend_analysis_type_param = "most_viewed"
        else:
            trend_analysis_type_param = "least_viewed"

        return trend_analysis_type_param

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        trend_analysis_type = tracker.get_slot("trend_analysis_type")
        filter_value = tracker.get_slot("filter_value")
        start_date = tracker.get_slot("start_date")
        end_date = tracker.get_slot("end_date")
        category = tracker.get_slot("category")
        date_format = "%d/%m/%Y"
        date_format_param = "%Y/%m/%d"

        # Can replace with data from db
        # categories = ["Shirt", "Pants", "Shoes"]

        if category:
            if start_date:
                start_date_parsed = datetime.strptime(start_date, date_format)
                end_date_parsed = datetime.strptime(end_date, date_format)

                trend_analysis_type_param = self.converse_trend_analysis_type(trend_analysis_type)

                start_date_param = start_date_parsed.strftime(date_format_param)
                end_date_param = end_date_parsed.strftime(date_format_param)
                filter_value = filter_value.lower()

                params = (trend_analysis_type_param, start_date_param, end_date_param, filter_value, category)
                result = DatabaseManager.call_stored_procedure(procedure_name="analyze_trend", params=params)

                if len(result) != 0:
                    print(f"Params for stored procedure: {params}")
                    print("Stored procedure result:\n", result)

                    total = 0
                    product_name = ""

                    if trend_analysis_type == "Best Seller" or trend_analysis_type == "Most View":
                        for row in result:
                            if row['total'] > total:
                                total = row['total']
                                product_name = row['product_name']
                    else:
                        for row in result:
                            if row['total'] < total:
                                total = row['total']
                                product_name = row['product_name']

                    # no_of_days = (end_date_parsed - start_date_parsed).days

                    report = (
                        f"Here is the result of {trend_analysis_type.lower()} for {category}, from {start_date} to {end_date}:\n"
                        f"- {product_name} with the total number is: {total}")

                else:
                    report = f"I am sorry but I cannot find any data regarding {trend_analysis_type.lower()} of {category}, from {start_date} to {end_date}."

            else:
                report = (f"Analysis type: {trend_analysis_type}\n"
                          f"Filter value: {filter_value}"
                          f"Trend report of {category}\n"
                          f"From the first date it got sold until {end_date}")
        else:
            if start_date:
                start_date_parsed = datetime.strptime(start_date, date_format)
                end_date_parsed = datetime.strptime(end_date, date_format)

                trend_analysis_type_param = self.converse_trend_analysis_type(trend_analysis_type)

                start_date_param = start_date_parsed.strftime(date_format_param)
                end_date_param = end_date_parsed.strftime(date_format_param)
                filter_value = filter_value.lower()
                category = ''

                params = (trend_analysis_type_param, start_date_param, end_date_param, filter_value, category)
                result = DatabaseManager.call_stored_procedure(procedure_name="analyze_trend", params=params)

                if len(result) != 0:
                    print("Result for trend analysis of all products:\n", result)

                    total = 0
                    product_name = ""

                    if trend_analysis_type == "Best Seller" or trend_analysis_type == "Most View":
                        for row in result:
                            if row['total'] > total:
                                total = row['total']
                                product_name = row['product_name']
                    else:
                        for row in result:
                            if row['total'] < total:
                                total = row['total']
                                product_name = row['product_name']

                    # no_of_days = (end_date_parsed - start_date_parsed).days

                    report = (
                        f"Here is the result of {trend_analysis_type.lower()}, from {start_date} to {end_date}:\n"
                        f"- {product_name} with the total number is: {total}")
                else:
                    report = f"I am sorry but I cannot find any data regarding {trend_analysis_type.lower()} of all products, from {start_date} to {end_date}."
            else:
                report = (f"Analysis type: {trend_analysis_type}\n"
                          f"Filter value: {filter_value}"
                          f"Trend report based on all products\n"
                          f"From the first date it got sold until {end_date}")


        dispatcher.utter_message(response="utter_analyzing_trends")
        dispatcher.utter_message(text=report)
        return []

    def parse_date(self, date_string: str) -> datetime:
        date_string = date_string.strip()

        today = datetime.now()

        if date_string.lower() in ['today', 'now']:
            return today
        elif date_string.lower() in ['yesterday']:
            return today - timedelta(days=1)
        elif date_string.lower() in ['tomorrow']:
            return today + timedelta(days=1)

        month_replacement = {
            'january': '01', 'jan': '01',
            'february': '02', 'feb': '02',
            'march': '03', 'mar': '03',
            'april': '04', 'apr': '04',
            'may': '05',
            'june': '06', 'jun': '06',
            'july': '07', 'jul': '07',
            'august': '08', 'aug': '08',
            'september': '09', 'sep': '09',
            'october': '10', 'oct': '10',
            'november': '11', 'nov': '11',
            'december': '12', 'dec': '12'
        }

        for month_name, month_num in month_replacement.items():
            date_string = re.sub(r'\b' + month_name + r'\b', month_num, date_string, flags=re.IGNORECASE)

        date_string = re.sub(r'[.,\s]+', '-', date_string)
        date_string = re.sub(r'-+', '-', date_string)

        date_formats = [
            "%Y-%m-%d",
            "%d-%m-%Y",
            "%m-%d-%Y",
            "%Y/%m/%d",
            "%d/%m/%Y",
            "%m/%d/%Y",
            "%Y %m %d",
            "%d %m %Y",
            "%m %d %Y",
        ]

        for fmt in date_formats:
            try:
                return datetime.strptime(date_string, fmt)
            except ValueError:
                continue

        for separator in ['-', '/', '.', ' ']:
            test_string = date_string.replace('-', separator)
            for fmt in date_formats:
                try:
                    return datetime.strptime(test_string, fmt.replace('-', separator))
                except ValueError:
                    continue

        raise ValueError(f"Unable to parse date: {date_string}")

    def generate_mock_trend_data(self, start_date: datetime, end_date: datetime) -> Dict[str, Any]:
        """Generate mock shopping trend data (replace with actual data fetching)"""

        # Calculate period duration
        duration = (end_date - start_date).days

        # Mock data categories
        categories = ["Electronics", "Clothing", "Home & Garden", "Books", "Sports", "Beauty"]

        # Generate mock metrics
        total_sales = random.randint(10000, 100000)
        total_orders = random.randint(500, 5000)
        avg_order_value = total_sales / total_orders

        # Generate category breakdown
        category_data = {}
        remaining_sales = total_sales

        for i, category in enumerate(categories):
            if i == len(categories) - 1:  # Last category gets remaining sales
                sales = remaining_sales
            else:
                sales = random.randint(1000, remaining_sales // 2)
                remaining_sales -= sales

            category_data[category] = {
                "sales": sales,
                "orders": random.randint(50, 500),
                "growth": round(random.uniform(-15.0, 25.0), 2)
            }

        # Generate top products
        top_products = [
            {"name": "Wireless Headphones", "sales": random.randint(1000, 5000), "category": "Electronics"},
            {"name": "Cotton T-Shirt", "sales": random.randint(800, 3000), "category": "Clothing"},
            {"name": "Plant Pot Set", "sales": random.randint(600, 2500), "category": "Home & Garden"},
            {"name": "Bestseller Novel", "sales": random.randint(400, 1500), "category": "Books"},
            {"name": "Yoga Mat", "sales": random.randint(300, 1200), "category": "Sports"}
        ]

        return {
            "period": f"{start_date.strftime('%d/%m/%Y')} to {end_date.strftime('%d/%m/%Y')}",
            "duration_days": duration,
            "total_sales": total_sales,
            "total_orders": total_orders,
            "avg_order_value": round(avg_order_value, 2),
            "categories": category_data,
            "top_products": top_products
        }

    def format_trend_report(self, data: Dict[str, Any], start_date: str, end_date: str, category: str) -> str:
        """Format the trend data into a readable report"""

        report = f"📊 **Shopping Trend Analysis Report**\n"
        report += f"📅 **Period:** {data['period']} ({data['duration_days']} days)\n\n"

        if category == "Shirt":
            report += f"👕 Product type: {category}"
        elif category == "Pants":
            report += f"👖 Product type: {category}"
        else:
            report += f"👟 Product type: {category}"

        report += f"💰 **Overall Performance:**\n"
        report += f"• Total Sales: ${data['total_sales']:,}\n"
        report += f"• Total Orders: {data['total_orders']:,}\n"
        report += f"• Average Order Value: ${data['avg_order_value']:.2f}\n\n"

        report += f"📈 **Category Performance:**\n"
        for category, metrics in data['categories'].items():
            growth_indicator = "📈" if metrics['growth'] > 0 else "📉" if metrics['growth'] < 0 else "➡️"
            report += f"• {category}: ${metrics['sales']:,} ({metrics['orders']} orders) {growth_indicator} {metrics['growth']}%\n"

        report += f"\n🏆 **Top Products:**\n"
        for i, product in enumerate(data['top_products'], 1):
            report += f"{i}. {product['name']} - ${product['sales']:,} ({product['category']})\n"

        report += f"\n📋 **Summary:**\n"
        best_category = max(data['categories'].items(), key=lambda x: x[1]['sales'])
        report += f"• Best performing category: {best_category[0]} with ${best_category[1]['sales']:,}\n"
        report += f"• Analysis completed for {data['duration_days']} days period\n"

        return report

class ActionAskTrendAnalysisType(Action):
    def name(self) -> Text:
        return "action_ask_trend_analysis_type"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        trend_analysis_template = ["Best Seller", "Least Seller", "Most View", "Least View"]
        text = ("What type of trend analysis you are looking for?"
                "Currently, I can help you check:\n")
        buttons = []

        for trend_analysis in trend_analysis_template:
            text += f"- {trend_analysis}\n"
            button = {
                "title": f"{trend_analysis}",
                "payload": f"{trend_analysis}"
            }
            buttons.append(button)

        dispatcher.utter_message(text=text, buttons=buttons)
        return []

class ActionAskAnalysisType(Action):
    def name(self) -> Text:
        return "action_ask_analysis_type"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        analysis_types = ["Shopping Trends"]

        text = ("Please give me the type of analysis that you want me to generate\n"
                "Currently I can support you with:\n")

        for analysis_type in analysis_types:
            text += f"- {analysis_type}\n"

        dispatcher.utter_message(text=text)
        return []

class ActionAskStartDate(Action):
    def name(self) -> Text:
        return "action_ask_start_date"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        text = "Please provide the start date that you want to analyze/report."

        dispatcher.utter_message(text=text)
        return []

class ActionAskEndDate(Action):
    def name(self) -> Text:
        return "action_ask_end_date"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        text = "Now I need the information about the end date for analysis/report."

        dispatcher.utter_message(text=text)
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

        categories = list_all_categories()
        buttons = []

        text = ("Which product type you want me to analyze/report?\n"
                f"Currently there are {len(categories)} types of product:\n")

        for category in categories:
            text += f"- {category}\n"

            button = {
                "title": f"{category}",
                "payload": f"{category}",
                "postback": f'/provide_category{{"category":"{category}"}}'
            }

            buttons.append(button)

        dispatcher.utter_message(text=text, buttons=buttons)
        return []

class ActionAskFilterValue(Action):
    def name(self) -> Text:
        return "action_ask_filter_value"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        filter_value_template = ["Product", "Category"]
        text = ("How do you want me to analyze/report ?"
                "For:\n")
        buttons = []

        for filter_value in filter_value_template:
            text += f"- {filter_value}\n"
            button = {
                "title": f"{filter_value}",
                "payload": f"{filter_value}"
            }
            buttons.append(button)

        dispatcher.utter_message(text=text, buttons=buttons)
        return []

class ValidateTrendForm(FormValidationAction):
    """ Validate the trend form """

    def name(self) -> Text:
        return "validate_trend_form"

    async def required_slots(
        self,
        domain_slots: List[Text],
        dispatcher: "CollectingDispatcher",
        tracker: "Tracker",
        domain: "DomainDict",
    ) -> List[Text]:

        updated_slot = domain_slots.copy()

        start_date = tracker.get_slot("start_date")
        end_date = tracker.get_slot("end_date")
        date_period = tracker.get_slot("date_period")
        filter_value = tracker.get_slot("filter_value")

        if end_date:
            if "now" in end_date.lower() and start_date is None:
                updated_slot.remove("start_date")

        if filter_value:
            if "product" in filter_value.lower() or "all" in filter_value.lower():
                updated_slot.remove("category")

        if (start_date is not None and date_period is None) or (end_date is not None and date_period is None):
            try:
                updated_slot.remove("date_period")
            except ValueError:
                pass

        # time_noun = tracker.get_slot("time_noun")
        #
        # if time_noun:
        #     latest_message = tracker.latest_message['text']
        #     prompt = (f"Detect for me the time in noun, exclude dates in numbers and month names, in this sentence: {latest_message}."
        #               f"If you can detect both the start and end date which are time in noun, then return start_date value_of_start_date end_date value_of_end_date."
        #               f"If you can only detect one then return: start_date value_of_start_date or end_date value_of_end_date."
        #               f"If you can detect the date in noun but the sentence does not provide any clue about start or end date then just return only the value of date."
        #               f"The date format I want you to return for me is %d/%m/%Y")
        #
        #     response = ActionAskGemini.call_llm_model(prompt)
        #     print(response.text)
        #     dates = (response.text).split()
        #
        #     print(f"Dates: {dates}")
        #
        #     if "start_date" in dates and "end_date" in dates:
        #         tracker.slots['start_date'] = dates[1]
        #         tracker.slots['end_date'] = dates[3]
        #     elif "start_date" in dates:
        #         tracker.slots['start_date'] = dates[1]
        #     elif "end_date" in dates:
        #         tracker.slots['end_date'] = dates[1]
        #     elif len(dates) == 1:
        #         start_date = tracker.get_slot("start_date")
        #         end_date = tracker.get_slot("end_date")
        #
        #         if start_date is None:
        #             tracker.slots['start_date'] = dates[0]
        #         elif end_date is None:
        #             tracker.slots['end_date'] = dates[0]

        return updated_slot

    def parse_date(self, date_string: str):
        # date_formats = [
        #     "%Y-%m-%d",
        #     "%d-%m-%Y",
        #     "%m-%d-%Y",
        #     "%Y/%m/%d",
        #     "%d/%m/%Y",
        #     "%m/%d/%Y",
        #     "%Y %m %d",
        #     "%d %m %Y",
        #     "%m %d %Y",
        #     "%B %d %Y",
        #     # "%B %d, %Y",
        #     "%b %d %Y",
        #     # "%b %d, %Y",
        #     "%d %B %Y",
        #     # "%d %B, %Y",
        #     "%d %b %Y",
        #     # "%d %b, %Y",
        # ]
        #
        # desired_format = "%d/%m/%Y"
        # pattern = re.compile(r'\b0*([1-9]|[12]\d|3[01])(?:st|nd|rd|th)\b')
        #
        # date_string = date_string.strip()
        # date_string = re.sub(r',+', ' ', date_string)
        # date_string = re.sub(r'\s+', ' ', date_string)
        # date_string = pattern.sub(r"\1", date_string)
        #
        # for fmt in date_formats:
        #     try:
        #         parsed_date = datetime.strptime(date_string, fmt)
        #         parsed_date = parsed_date.strftime(desired_format)
        #         return parsed_date
        #     except ValueError:
        #         continue
        #
        # raise ValueError(f"Unable to parse date: {date_string}")

        current_year = datetime.now().year
        prompt = f"Check spelling of this date string: {date_string}. If there are any misspellings, correct it and return only the date string in the format of %d/%m/%Y for me. If you can detect that there are only day and month only set the year to this year: {current_year}. If you think it is not a date then return only date_error for me"
        response = ActionAskGemini.call_llm_model(prompt)
        date_string = response.text

        print(date_string)

        if date_string != "date_error":
            return date_string

        return None

    def validate_trend_analysis_type(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict, ) -> Dict[Text, Any]:

        trend_analysis_template = ["Best Seller", "Least Seller", "Most View", "Least View"]
        trend_analysis_type = slot_value

        if trend_analysis_type:
            if trend_analysis_type in trend_analysis_template:
                return {"trend_analysis_type": trend_analysis_type}
        else:
            text = "I am sorry but I don't understand the type of trend analysis that you want"
            dispatcher.utter_message(text=text)
            return {"trend_analysis_type": None}

    def validate_analysis_type(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict, ) -> Dict[Text, Any]:

            analysis_type = slot_value
            print("Analysis type: ", analysis_type)
            analysis_types = ["Shopping Trends"]

            if analysis_type is not None:
                if analysis_type in analysis_types:
                    return {"analysis_type": analysis_type}
                else:
                    text = f"I am sorry but currently I cannot support this type of analysis: {analysis_type}"
                    dispatcher.utter_message(text=text)
                    return {"analysis_type": None}

            return {"analysis_type": None}

    def validate_filter_value(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict, ) -> Dict[Text, Any]:

        filter_value_template = ["Product", "Category"]
        filter_value = slot_value

        if filter_value:
            if filter_value in filter_value_template:
                return {"filter_value": filter_value}
            elif "all" in filter_value.lower():
                return {"filter_value": "Product"}
        else:
            text = "I don't understand this filter value"
            dispatcher.utter_message(text=text)
            return {"filter_value": None}

    def validate_start_date(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict,) -> Dict[Text, Any]:

        """ This function is used to validate start date"""

        start_date = slot_value
        date_format = r"%d/%m/%Y"

        # Check if start_date is in the slot
        if start_date:
            if "now" in start_date.lower() or "today" in start_date.lower():
                start_date = (datetime.today()).strftime(date_format)
            elif "yesterday" in start_date.lower():
                start_date = (datetime.now() - timedelta(days=1)).strftime(date_format)
            elif "tomorrow" in start_date.lower():
                start_date = (datetime.now() + timedelta(days=1)).strftime(date_format)
            else:
                date_formats = [
                    "%Y-%m-%d",
                    "%d-%m-%Y",
                    "%m-%d-%Y",
                    "%Y/%m/%d",
                    "%d/%m/%Y",
                    "%m/%d/%Y",
                    "%Y %m %d",
                    "%d %m %Y",
                    "%m %d %Y",
                    "%B %d %Y",
                    "%B %d, %Y",
                    "%b %d %Y",
                    "%b %d, %Y",
                    "%d %B %Y",
                    "%d %B, %Y",
                    "%d %b %Y",
                    "%d %b, %Y",
                ]

                valid_date = False
                for fmt in date_formats:
                    try:
                        parsed_date = datetime.strptime(start_date, fmt)
                        valid_date = True
                        break
                    except ValueError:
                        continue

                if valid_date:
                    start_date = parsed_date.strftime("%d/%m/%Y")
                else:
                    start_date = self.parse_date(start_date)

            print(f"Start date: {start_date}")

            # Check if the start_date is a valid date by asking Gemini to do it
            if start_date:
                current_date = (datetime.today()).strftime(date_format)
                end_date = tracker.get_slot("end_date")

                start_date_parsed = datetime.strptime(start_date, date_format)
                current_date_parsed = datetime.strptime(current_date, date_format)
                # print("Reached inside of start_date here")
                # print(f"Start date: {start_date}, start date parsed: {start_date_parsed}")
                # print(f"Current date: {current_date}, current date parsed: {current_date_parsed}")

                if start_date_parsed > current_date_parsed:
                    # print("Reached check current_date here")
                    text = "I am sorry but the start date must be or before the current date"
                    dispatcher.utter_message(text=text)
                    print("Reached set start_date to None here")
                    return {"start_date": None}
                elif end_date:
                    if "now" in end_date.lower() or "today" in end_date.lower():
                        end_date = (datetime.today()).strftime(date_format)
                    elif "yesterday" in end_date.lower():
                        end_date = (datetime.now() - timedelta(days=1)).strftime(date_format)
                    elif "tomorrow" in end_date.lower():
                        end_date = (datetime.now() + timedelta(days=1)).strftime(date_format)
                    else:
                        end_date = self.parse_date(end_date)

                    start_date_parsed = datetime.strptime(start_date, date_format)
                    end_date_parsed = datetime.strptime(end_date, date_format)

                    if end_date_parsed < start_date_parsed:
                        text = "I am sorry but the end date must not be before start date"
                        print("Reached here first 1")
                        dispatcher.utter_message(text=text)
                        return {"start_date": start_date, "end_date": None}
                    else:
                        return {"start_date": start_date, "end_date": end_date}

                print(f"Start date before set to slot: {start_date}")
                return {"start_date": start_date}
            else:
                dispatcher.utter_message(response="utter_invalid_date")
                return {"start_date": None}
        else:
            print("Check 1")
            dispatcher.utter_message(response="utter_invalid_date")
            return {"start_date": None}

        # try:
        #     parsed_date = self.parse_date(slot_value)
        #     return {"start_date": parsed_date}
        #
        # except ValueError:
        #     print("Check 2")
        #     text = f"I am sorry but apparently your date is invalid. Please check your input date again: {slot_value}"
        #     dispatcher.utter_message(text=text)
        #     return {"start_date": None}

    def validate_end_date(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict,) -> Dict[Text, Any]:

        end_date = slot_value
        date_format = r"%d/%m/%Y"

        if end_date:
            start_date = tracker.get_slot("start_date")
            if start_date is None:
                return {"start_date": None}
            else:
                start_date_parsed = datetime.strptime(start_date, date_format)

            if "now" in end_date.lower() or "today" in end_date.lower():
                end_date = (datetime.today()).strftime(date_format)
            elif "yesterday" in end_date.lower():
                end_date = (datetime.now() - timedelta(days=1)).strftime(date_format)
            elif "tomorrow" in end_date.lower():
                end_date = (datetime.now() + timedelta(days=1)).strftime(date_format)
            else:
                date_formats = [
                    "%Y-%m-%d",
                    "%d-%m-%Y",
                    "%m-%d-%Y",
                    "%Y/%m/%d",
                    "%d/%m/%Y",
                    "%m/%d/%Y",
                    "%Y %m %d",
                    "%d %m %Y",
                    "%m %d %Y",
                    "%B %d %Y",
                    "%B %d, %Y",
                    "%b %d %Y",
                    "%b %d, %Y",
                    "%d %B %Y",
                    "%d %B, %Y",
                    "%d %b %Y",
                    "%d %b, %Y",
                ]

                valid_date = False
                for fmt in date_formats:
                    try:
                        parsed_date = datetime.strptime(end_date, fmt)
                        valid_date = True
                        break
                    except ValueError:
                        continue

                if valid_date:
                    end_date = parsed_date.strftime("%d/%m/%Y")
                else:
                    end_date = self.parse_date(end_date)

            if end_date:
                end_date_parsed = datetime.strptime(end_date, date_format)

                if end_date_parsed < start_date_parsed:
                    print("Reached here first 2")
                    dispatcher.utter_message(response="utter_date_range_error")
                    return {"end_date": None}

                return {"end_date": end_date}
        else:
            dispatcher.utter_message(response="utter_invalid_date")
            return {"end_date": None}

        # if not slot_value:
        #
        #
        # try:
        #     end_date = self.parse_date(slot_value)
        #     start_date = tracker.get_slot("start_date")
        #
        #
        #     if start_date:
        #         try:
        #             start_date = self.parse_date(start_date)
        #
        #             end_date_parsed = datetime.strptime(end_date, "%d/%m/%Y")
        #             start_date_parsed = datetime.strptime(start_date, "%d/%m/%Y")
        #
        #             if end_date_parsed <= start_date_parsed:
        #                 dispatcher.utter_message(response="utter_date_range_error")
        #                 return {"end_date": None}
        #
        #         except ValueError:
        #             pass
        #
        #     return {"end_date": end_date}
        #
        # except ValueError:
        #     text = f"I am sorry but apparently your date is invalid. Please check your input date again: {slot_value}"
        #     dispatcher.utter_message(text=text)
        #     return {"end_date": None}

    def validate_category(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict, ) -> Dict[Text, Any]:

        categories = list_all_categories()
        print(categories)
        category = slot_value

        if category in categories:
            return {"category": category, "filter_value": "Category"}
        else:
            dispatcher.utter_message(text=f"I am sorry but I cannot find this category: {category}\n")
            return {"category": None}

    def validate_date_period(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict, ) -> Dict[Text, Any]:

        date_period = slot_value
        start_date = tracker.get_slot("start_date")
        end_date = tracker.get_slot("end_date")

        if date_period is not None and start_date is None and end_date is None:
            current_date = datetime.now().strftime("%d/%m/%Y")
            prompt = (
                f"This is the current date: {current_date} and the date format that I want you to return is: %d/%m/%Y "
                f"Base on the current date that I gave you and this period of time: {date_period}."
                f"No need to explain anything more, just return for me only: start_date value_of_start_date end_date value_of_end_date."
                f"If it is last week/month/quarter/year or something similar like that. Then the start date will be the start date of that week/month/quarter/year and the end date will the end date of that week/month/quarter/year."
                f"If it is one day or many days ago, then the value of the start date will be the current date minus that number of days and the value of the end date will be the current date."
                f"If it is a number of week/month/quarter/year ago, then the start date value will be the start of that week/month/quarter/year ago based on the current week/month/quarter/year from the current date, the end date will be the end date of the previous week/month/quarter/year of recent week/month/quarter/year."
                f"If it is last a number of week/month/quarter/year, then the start date value will be the start of that week/month/quarter/year ago based on the current week/month/quarter/year from the current date, the end date will be the end date of the previous week/month/quarter/year of recent week/month/quarter/year."
                f"If it is previous a number of week/month/quarter/year, then the start date value will be the start of that week/month/quarter/year ago based on the current week/month/quarter/year from the current date, the end date will be the end date of the previous week/month/quarter/year of recent week/month/quarter/year."
                f"If it is a number of previous week/month/quarter/year, then the start date value will be the start of that week/month/quarter/year ago based on the current week/month/quarter/year from the current date, the end date will be the end date of the previous week/month/quarter/year of recent week/month/quarter/year."
                f"If it is past a number of week/month/quarter/year, then the start date value will be the start of that week/month/quarter/year ago based on the current week/month/quarter/year from the current date, the end date will be the end date of the previous week/month/quarter/year of recent week/month/quarter/year."
                f"If it is current time like this week/month/quarter/year, then the value of start date will the start date of that week/month/quarter/year and the value of the end date will be the current date.")

            response = ActionAskGemini.call_llm_model(prompt)
            dates = response.text.split()
            print(f"Date response from Gemini: {dates}")

            start_date = dates[1]
            end_date = dates[3]

            return {"date_period": date_period, "start_date": start_date, "end_date": end_date}

        return {"date_period": None}

    # def run(
    #     self,
    #     dispatcher: CollectingDispatcher,
    #     tracker: Tracker,
    #     domain: DomainDict,
    # ) -> List[EventType]:
    #
    #     date_period = tracker.get_slot("date_period")
    #     start_date = tracker.get_slot("start_date")
    #     end_date = tracker.get_slot("end_date")
    #     current_date = datetime.now().strftime("%d/%m/%Y")
    #     print("Reached run function of validate trend form")
    #
    #     if date_period is not None and start_date is None and end_date is None:
    #         prompt = (f"This is the current date: {current_date} and the date format that I want you to return is: %d/%m/%Y "
    #                   f"Base on the current date that I gave you and this period of time: {date_period}."
    #                   f"No need to explain anything more, just return for me only: start_date value_of_start_date end_date value_of_end_date."
    #                   f"If it is past time last week/month/quarter/year or something similar like that. Then the start date will be the start date of that week/month/quarter/year and the end date will the end date of that week/month/quarter/year."
    #                   f"If it is one day or many days ago, then the value of the start date will be the current date minus that number of days and the value of the end date will be the current date."
    #                   f"If it is a number of week/month/quarter/year ago, then the start date value will be the start of that week/month/quarter/year ago based on the current week/month/quarter/year from the current date, the end date will be the end date of week/month/quarter/year after the previous mentioned number of week/month/quarter/year later"
    #                   f"If it is current time like this week/month/quarter/year, then the value of start date will the start date of that week/month/quarter/year and the value of the end date will be the current date.")
    #
    #         response = ActionAskGemini.call_llm_model(prompt)
    #         dates = response.text.split()
    #         print(f"Date response from Gemini: {dates}")
    #
    #         start_date = dates[1]
    #         end_date = dates[3]
    #
    #         return [
    #             SlotSet("start_date", start_date),
    #             SlotSet("end_date", end_date)
    #         ]
    #
    #     return []

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

# class ActionInformProductType(Action):
#     def name(self) -> Text:
#         return "action_inform_category"
#
#     def run(
#         self,
#         dispatcher: "CollectingDispatcher",
#         tracker: Tracker,
#         domain: "DomainDict",
#     ) -> List[Dict[Text, Any]]:
#
#         categories = ["Shirt", "Pants", "Shoes"]
#
#         dispatcher.utter_message(text=f"Currently there are {len(categories)} product types:\n")
#         categories_text = ""
#
#         for category in categories:
#             categories_text += f"- {category}\n"
#
#         dispatcher.utter_message(text=categories_text)
#         return []

class ActionHandleDateRange(Action):
    def name(self) -> Text:
        return "action_handle_date_range"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        start_date = tracker.get_slot("start_date")
        end_date = tracker.get_slot("end_date")
        category = tracker.get_slot("category")
        category = category.lower()

        # Can replace with data from db
        categories = ["shirt", "pants", "shoes"]


        if start_date and end_date and category:
            dispatcher.utter_message(text=f"Great! I have your date range: {start_date} to {end_date}, and the product type is: {category}. Let me generate the shopping trend analysis for you.")
            return [FollowupAction("action_generate_trend_report")]
        elif start_date and end_date and category not in categories:
            dispatcher.utter_message(text=f"I have the information about your date range: {start_date} to {end_date}, however this shop does not appear to have this type of product: {category}")
            return [ActiveLoop("trend_form")]
        elif not start_date and not end_date and category:
            dispatcher.utter_message(text=f"I have the information about the product type: {category}, but I need both start and end dates for the trend analysis. Let me collect the missing information.")
            return [ActiveLoop("trend_form")]
        else:
            dispatcher.utter_message(text=f"I am sorry but I need information about both start and end dates, and product type for the trend analysis. Let me collect the missing information.")
            return [ActiveLoop("trend_form")]

class ActionAskReportType(Action):
    def name(self) -> Text:
        return "action_ask_report_type"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:


        report_types = ["Shopping trends", "Profit", "Revenue"]
        buttons = []
        text = ("What type of report you want me to generate for you?\n"
                "Currently I can help you with 3 types of report:\n")

        for report_type in report_types:
            text += f"- {report_type}\n"

            button = {
                "title": f"{report_type}",
                "payload": f"{report_type}",
                "postback": f'/provide_report_type{{"report_type":"{report_type}"}}'
            }

            buttons.append(button)

        dispatcher.utter_message(text=text, buttons=buttons)
        return []

class ActionAskReportAmount(Action):
    def name(self) -> Text:
        return "action_ask_report_amount"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:


        report_type = tracker.get_slot("report_type")
        amount_template = ["All", "One"]
        buttons = []
        text = (f"Please choose the number of products you want me to generate {report_type} report.\n"
                f"Currently I can help you with 2 options:\n")

        for amount in amount_template:
            if amount == "One":
                text += f"- {amount} product\n"
                button = {
                    "title": f"{amount} product",
                    "payload": f"{amount} product",
                    "postback": f'/provide_report_amount{{"report_amount":"{amount}"}}'
                }
            else:
                text += f"- {amount} products\n"
                button = {
                    "title": f"{amount} products",
                    "payload": f"{amount} products"
                }

            buttons.append(button)

        dispatcher.utter_message(text=text, buttons=buttons)
        return []

class ActionAskProductId(Action):
    def name(self) -> Text:
        return "action_ask_product_id"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        text = "Could you provide me the ID of the product that you want to know?"
        dispatcher.utter_message(text=text)
        return []

class ActionAskStep(Action):
    def name(self) -> Text:
        return "action_ask_step"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        step_dict = {
            "One day": "one day",
            "One week": "one week",
            "One month": "one month",
            "One year": "one year"
        }

        report_type = tracker.get_slot("report_type")
        text = (f"Can you provide me the step for the {report_type} report?\n"
                f"Currently I can help you with these kinds of step:\n")
        buttons = []

        for key, value in step_dict.items():
            text += f"- {key}\n"

            button = {
                "title": f"{key}",
                "payload": f"{value}"
            }

            buttons.append(button)

        dispatcher.utter_message(text=text, buttons=buttons)
        return []


class ValidateProfitRevenueForm(FormValidationAction):
    def name(self) -> Text:
        return "validate_profit_revenue_form"

    async def required_slots(
        self,
        domain_slots: List[Text],
        dispatcher: "CollectingDispatcher",
        tracker: "Tracker",
        domain: "DomainDict",
    ) -> List[Text]:

        updated_slots = domain_slots.copy()

        report_amount = tracker.get_slot("report_amount")
        product_id = tracker.get_slot("product_id")
        filter_value = tracker.get_slot("filter_value")
        category = tracker.get_slot("category")
        start_date = tracker.get_slot("start_date")
        end_date = tracker.get_slot("end_date")
        date_period = tracker.get_slot("date_period")

        if filter_value:
            if filter_value == "Product":
                updated_slots.remove("category")

        if report_amount is not None:
            if report_amount == "All":
                updated_slots.remove("product_id")
            # elif report_amount == "One":
                # updated_slots.remove("filter_value")
                # updated_slots.remove("category")

        if product_id is not None and filter_value is None and category is None:
            try:
                updated_slots.remove("filter_value")
                updated_slots.remove("category")
            except ValueError:
                pass

        if (start_date is not None and date_period is None) or (end_date is not None and date_period is None):
            try:
                updated_slots.remove("date_period")
            except ValueError:
                pass

        return updated_slots

    def parse_date(self, date_string: str):
        # date_formats = [
        #     "%Y-%m-%d",
        #     "%d-%m-%Y",
        #     "%m-%d-%Y",
        #     "%Y/%m/%d",
        #     "%d/%m/%Y",
        #     "%m/%d/%Y",
        #     "%Y %m %d",
        #     "%d %m %Y",
        #     "%m %d %Y",
        #     "%B %d %Y",
        #     # "%B %d, %Y",
        #     "%b %d %Y",
        #     # "%b %d, %Y",
        #     "%d %B %Y",
        #     # "%d %B, %Y",
        #     "%d %b %Y",
        #     # "%d %b, %Y",
        # ]
        #
        # desired_format = "%d/%m/%Y"
        # pattern = re.compile(r'\b0*([1-9]|[12]\d|3[01])(?:st|nd|rd|th)\b')
        #
        # date_string = date_string.strip()
        # date_string = re.sub(r',+', ' ', date_string)
        # date_string = re.sub(r'\s+', ' ', date_string)
        # date_string = pattern.sub(r"\1", date_string)
        #
        # for fmt in date_formats:
        #     try:
        #         parsed_date = datetime.strptime(date_string, fmt)
        #         parsed_date = parsed_date.strftime(desired_format)
        #         return parsed_date
        #     except ValueError:
        #         continue
        #
        # raise ValueError(f"Unable to parse date: {date_string}")

        current_year = datetime.now().year
        prompt = f"Check spelling of this date string: {date_string}. If there are any misspellings, correct it and return only the date string in the format of %d/%m/%Y for me. If you can detect that there are only day and month only set the year to this year: {current_year}. If you think it is not a date then return only date_error for me"
        response = ActionAskGemini.call_llm_model(prompt)
        date_string = response.text

        print(date_string)

        if date_string != "date_error":
            return date_string

        return None

    def validate_filter_value(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict, ) -> Dict[Text, Any]:

        filter_value_template = ["Product", "Category"]
        filter_value = slot_value

        if filter_value:
            if filter_value in filter_value_template:
                return {"filter_value": filter_value}
            elif "all" in filter_value.lower():
                return {"filter_value": "Product"}
        else:
            text = "I don't understand this filter value"
            dispatcher.utter_message(text=text)
            return {"filter_value": None}

    def validate_category(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict, ) -> Dict[Text, Any]:

        categories = list_all_categories()
        print(categories)
        category = slot_value

        if category in categories:
            return {"category": category, "filter_value": "Category"}
        else:
            dispatcher.utter_message(text=f"I am sorry but I cannot find this category: {category}\n")
            return {"category": None}

    def validate_start_date(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict, ) -> Dict[Text, Any]:

        """ This function is used to validate start date"""

        start_date = slot_value
        date_format = r"%d/%m/%Y"

        # Check if start_date is in the slot
        if start_date:
            if "now" in start_date.lower() or "today" in start_date.lower():
                start_date = (datetime.today()).strftime(date_format)
            elif "yesterday" in start_date.lower():
                start_date = (datetime.now() - timedelta(days=1)).strftime(date_format)
            elif "tomorrow" in start_date.lower():
                start_date = (datetime.now() + timedelta(days=1)).strftime(date_format)
            else:
                date_formats = [
                    "%Y-%m-%d",
                    "%d-%m-%Y",
                    "%m-%d-%Y",
                    "%Y/%m/%d",
                    "%d/%m/%Y",
                    "%m/%d/%Y",
                    "%Y %m %d",
                    "%d %m %Y",
                    "%m %d %Y",
                    "%B %d %Y",
                    "%B %d, %Y",
                    "%b %d %Y",
                    "%b %d, %Y",
                    "%d %B %Y",
                    "%d %B, %Y",
                    "%d %b %Y",
                    "%d %b, %Y",
                ]

                valid_date = False
                for fmt in date_formats:
                    try:
                        parsed_date = datetime.strptime(start_date, fmt)
                        valid_date = True
                        break
                    except ValueError:
                        continue

                if valid_date:
                    start_date = parsed_date.strftime("%d/%m/%Y")
                else:
                    start_date = self.parse_date(start_date)

            print(f"Start date: {start_date}")

            # Check if the start_date is a valid date by asking Gemini to do it
            if start_date:
                current_date = (datetime.today()).strftime(date_format)
                end_date = tracker.get_slot("end_date")

                start_date_parsed = datetime.strptime(start_date, date_format)
                current_date_parsed = datetime.strptime(current_date, date_format)
                # print("Reached inside of start_date here")
                # print(f"Start date: {start_date}, start date parsed: {start_date_parsed}")
                # print(f"Current date: {current_date}, current date parsed: {current_date_parsed}")

                if start_date_parsed > current_date_parsed:
                    # print("Reached check current_date here")
                    text = "I am sorry but the start date must be or before the current date"
                    dispatcher.utter_message(text=text)
                    print("Reached set start_date to None here")
                    return {"start_date": None}
                elif end_date:
                    if "now" in end_date.lower() or "today" in end_date.lower():
                        end_date = (datetime.today()).strftime(date_format)
                    elif "yesterday" in end_date.lower():
                        end_date = (datetime.now() - timedelta(days=1)).strftime(date_format)
                    elif "tomorrow" in end_date.lower():
                        end_date = (datetime.now() + timedelta(days=1)).strftime(date_format)
                    else:
                        end_date = self.parse_date(end_date)

                    start_date_parsed = datetime.strptime(start_date, date_format)
                    end_date_parsed = datetime.strptime(end_date, date_format)

                    if end_date_parsed < start_date_parsed:
                        text = "I am sorry but the end date must not be before start date"
                        print("Reached here first 1")
                        dispatcher.utter_message(text=text)
                        return {"start_date": start_date, "end_date": None}
                    else:
                        return {"start_date": start_date, "end_date": end_date}

                print(f"Start date before set to slot: {start_date}")
                return {"start_date": start_date}
            else:
                dispatcher.utter_message(response="utter_invalid_date")
                return {"start_date": None}
        else:
            print("Check 1")
            dispatcher.utter_message(response="utter_invalid_date")
            return {"start_date": None}

        # try:
        #     parsed_date = self.parse_date(slot_value)
        #     return {"start_date": parsed_date}
        #
        # except ValueError:
        #     print("Check 2")
        #     text = f"I am sorry but apparently your date is invalid. Please check your input date again: {slot_value}"
        #     dispatcher.utter_message(text=text)
        #     return {"start_date": None}

    def validate_end_date(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict, ) -> Dict[Text, Any]:

        end_date = slot_value
        date_format = r"%d/%m/%Y"

        if end_date:
            start_date = tracker.get_slot("start_date")
            if start_date is None:
                return {"start_date": None}
            else:
                start_date_parsed = datetime.strptime(start_date, date_format)

            if "now" in end_date.lower() or "today" in end_date.lower():
                end_date = (datetime.today()).strftime(date_format)
            elif "yesterday" in end_date.lower():
                end_date = (datetime.now() - timedelta(days=1)).strftime(date_format)
            elif "tomorrow" in end_date.lower():
                end_date = (datetime.now() + timedelta(days=1)).strftime(date_format)
            else:
                date_formats = [
                    "%Y-%m-%d",
                    "%d-%m-%Y",
                    "%m-%d-%Y",
                    "%Y/%m/%d",
                    "%d/%m/%Y",
                    "%m/%d/%Y",
                    "%Y %m %d",
                    "%d %m %Y",
                    "%m %d %Y",
                    "%B %d %Y",
                    "%B %d, %Y",
                    "%b %d %Y",
                    "%b %d, %Y",
                    "%d %B %Y",
                    "%d %B, %Y",
                    "%d %b %Y",
                    "%d %b, %Y",
                ]

                valid_date = False
                for fmt in date_formats:
                    try:
                        parsed_date = datetime.strptime(end_date, fmt)
                        valid_date = True
                        break
                    except ValueError:
                        continue

                if valid_date:
                    end_date = parsed_date.strftime("%d/%m/%Y")
                else:
                    end_date = self.parse_date(end_date)

            if end_date:
                end_date_parsed = datetime.strptime(end_date, date_format)

                if end_date_parsed < start_date_parsed:
                    print("Reached here first 2")
                    dispatcher.utter_message(response="utter_date_range_error")
                    return {"end_date": None}

                return {"end_date": end_date}
        else:
            dispatcher.utter_message(response="utter_invalid_date")
            return {"end_date": None}

        # if not slot_value:
        #
        #
        # try:
        #     end_date = self.parse_date(slot_value)
        #     start_date = tracker.get_slot("start_date")
        #
        #
        #     if start_date:
        #         try:
        #             start_date = self.parse_date(start_date)
        #
        #             end_date_parsed = datetime.strptime(end_date, "%d/%m/%Y")
        #             start_date_parsed = datetime.strptime(start_date, "%d/%m/%Y")
        #
        #             if end_date_parsed <= start_date_parsed:
        #                 dispatcher.utter_message(response="utter_date_range_error")
        #                 return {"end_date": None}
        #
        #         except ValueError:
        #             pass
        #
        #     return {"end_date": end_date}
        #
        # except ValueError:
        #     text = f"I am sorry but apparently your date is invalid. Please check your input date again: {slot_value}"
        #     dispatcher.utter_message(text=text)
        #     return {"end_date": None}

    def validate_report_type(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict, ) -> Dict[Text, Any]:

        report_types = ["Profit", "Revenue"]
        report_type = slot_value

        if report_type in report_types:
            return {"report_type": report_type}
        else:
            dispatcher.utter_message(text=f"I am sorry but apparently I cannot generate for you this type of report: {report_type}")
            return {"report_type": None}

    def validate_report_amount(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict, ) -> Dict[Text, Any]:

        template_amount = ["All", "One"]
        report_amount = slot_value
        report_type = tracker.get_slot("report_type")

        if slot_value in template_amount:
            return {"report_amount": report_amount}
        else:
            dispatcher.utter_message(text=f"I am sorry but I cannot generate for you {report_type} report with this report amount: {report_amount}")
            return {"report_amount": None}

    def validate_product_id(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict, ) -> Dict[Text, Any]:

        total_id = count_all_product_type_id()

        try:
            product_id = int(slot_value)
            if 0 <= product_id <= total_id:
                return {"product_id": product_id, "report_amount": "One"}
            else:
                text = f"I already checked the shop but apparently there isn't any product with the id: {product_id}"
                dispatcher.utter_message(text=text)
                return {"product_id": None, "report_amount": "One"}

        except ValueError:
            text = f"It seems like you just input an invalid ID. The ID of a product must be a number like: 1, 2, 3,..."
            dispatcher.utter_message(text=text)
            return {"product_id": None, "report_amount": "One"}

    def validate_step(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict, ) -> Dict[Text, Any]:

            step_template = [1, 7, 30, 365]
            step = slot_value

            if step:
                try:
                    step = int(step)
                    return {"step": step}

                except ValueError:
                    prompt = f"Please detect the number of days in this sentence: {step}. Your response is just the number of days only, you don't have to add anything more in your answer."
                    response = ActionAskGemini.call_llm_model(prompt)
                    print(response.text)

                    try:
                        step = int(response.text)
                        if step in step_template:
                            return {"step":  step}
                        else:
                            text = "I am sorry, but currently I cannot support you with this kind of step"
                            dispatcher.utter_message(text=text)
                            return {"step": None}

                    except ValueError:
                        text = "I am sorry but apparently, I cannot understand your step. Can you please rephrase it?"
                        dispatcher.utter_message(text=text)
                        return {"step": None}
            else:
                return {"step": None}

    def validate_date_period(
            self,
            slot_value: Any,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: DomainDict, ) -> Dict[Text, Any]:

        date_period = slot_value
        start_date = tracker.get_slot("start_date")
        end_date = tracker.get_slot("end_date")

        if date_period is not None and start_date is None and end_date is None:
            current_date = datetime.now().strftime("%d/%m/%Y")
            prompt = (
                f"This is the current date: {current_date} and the date format that I want you to return is: %d/%m/%Y "
                f"Base on the current date that I gave you and this period of time: {date_period}."
                f"No need to explain anything more, just return for me only: start_date value_of_start_date end_date value_of_end_date."
                f"If it is last week/month/quarter/year. Then the start date will be the start date of that week/month/quarter/year and the end date will the end date of that week/month/quarter/year."
                f"If it is one day or many days ago, then the value of the start date will be the current date minus that number of days and the value of the end date will be the current date."
                f"If it is a number of week/month/quarter/year ago, then the start date value will be the start of that week/month/quarter/year ago based on the current week/month/quarter/year from the current date, the end date will be the end date of the previous week/month/quarter/year of recent week/month/quarter/year."
                f"If it is last a number of week/month/quarter/year, then the start date value will be the start of that week/month/quarter/year ago based on the current week/month/quarter/year from the current date, the end date will be the end date of the previous week/month/quarter/year of recent week/month/quarter/year."
                f"If it is previous a number of week/month/quarter/year, then the start date value will be the start of that week/month/quarter/year ago based on the current week/month/quarter/year from the current date, the end date will be the end date of the previous week/month/quarter/year of recent week/month/quarter/year."
                f"If it is a number of previous week/month/quarter/year, then the start date value will be the start of that week/month/quarter/year ago based on the current week/month/quarter/year from the current date, the end date will be the end date of the previous week/month/quarter/year of recent week/month/quarter/year."
                f"If it is past a number of week/month/quarter/year, then the start date value will be the start of that week/month/quarter/year ago based on the current week/month/quarter/year from the current date, the end date will be the end date of the previous week/month/quarter/year of recent week/month/quarter/year."
                f"If it is current time like this week/month/quarter/year, then the value of start date will the start date of that week/month/quarter/year and the value of the end date will be the current date.")

            response = ActionAskGemini.call_llm_model(prompt)
            dates = response.text.split()
            print(f"Date response from Gemini: {dates}")

            start_date = dates[1]
            end_date = dates[3]

            return {"date_period": date_period, "start_date": start_date, "end_date": end_date}

        return {"date_period": None}


class ActionGenerateProfitRevenueReport(Action):
    def name(self) -> Text:
        return "action_generate_profit_revenue_report"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        report_type = (tracker.get_slot("report_type")).lower()
        filter_value = (tracker.get_slot("filter_value")).lower()
        category = tracker.get_slot("category")
        product_id = tracker.get_slot("product_id")
        report_amount = tracker.get_slot("report_amount")
        start_date = tracker.get_slot("start_date")
        end_date = tracker.get_slot("end_date")
        step = tracker.get_slot("step")

        date_format = "%d/%m/%Y"
        date_format_param = "%Y-%m-%d"

        start_date_param = (datetime.strptime(start_date, date_format)).strftime(date_format_param)
        end_date_param = (datetime.strptime(end_date, date_format)).strftime(date_format_param)

        total_sum = 0

        if category:
            if report_amount == "All":
                product_id = 0
                params = (filter_value, category, start_date_param, end_date_param, report_type, product_id, step)
                result = DatabaseManager.call_stored_procedure(procedure_name="view_profit_report", params=params)

                if len(result) != 0:
                    report = (f"Here is the {report_type} of {report_amount.lower()} products from {category}.\n"
                              f"From {start_date} to {end_date}:\n")

                    for row in result:
                        period_start = datetime.strptime(str(row['period_start']), "%Y-%m-%d")
                        period_end = datetime.strptime(str(row['period_end']), "%Y-%m-%d")
                        total = row['total']

                        if total is None:
                            total = 0

                        total_sum += total

                        report += f"{period_start} to {period_end}: {total}\n"

                    report += f"With total {report_type} is: {total_sum}"
                else:
                    report = f"I am sorry but there is no data regarding {report_type} of {report_amount} products of {category}, from {start_date} to {end_date}"

                print(f"Result of {report_type}:\n", result)

                print("Result of profit:\n", result)
            elif report_amount == "One":
                params = (filter_value, category, start_date_param, end_date_param, report_type, product_id, step)
                result = DatabaseManager.call_stored_procedure(procedure_name="view_profit_report", params=params)

                if len(result) != 0:
                    report = (
                        f"Here is the {report_type} of {report_amount.lower()} product from {category}, with id: {product_id}.\n"
                        f"From {start_date} to {end_date}:\n")

                    for row in result:
                        period_start = datetime.strptime(str(row['period_start']), "%Y-%m-%d")
                        period_end = datetime.strptime(str(row['period_end']), "%Y-%m-%d")
                        total = row['total']

                        if total is None:
                            total = 0

                        total_sum += total

                        report += f"{period_start} to {period_end}: {total}\n"

                    report += f"With total {report_type} is: {total_sum}"
                else:
                    report = f"I am sorry but there is no data regarding {report_type} of product with id: {product_id} of {category}, from {start_date} to {end_date}"

                print(f"Result of {report_type}:\n", result)
        else:
            category = ''
            if report_amount == "All":
                product_id = 0
                params = (filter_value, category, start_date_param, end_date_param, report_type, product_id, step)
                result = DatabaseManager.call_stored_procedure(procedure_name="view_profit_report", params=params)

                if len(result) != 0:
                    report = (f"Here is the {report_type} of {report_amount.lower()} products.\n"
                              f"From {start_date} to {end_date}:\n")

                    for row in result:
                        period_start = datetime.strptime(str(row['period_start']), "%Y-%m-%d")
                        period_end = datetime.strptime(str(row['period_end']), "%Y-%m-%d")
                        total = row['total']

                        if total is None:
                            total = 0

                        total_sum += total

                        report += f"{period_start} to {period_end}: {total}\n"

                    report += f"With total {report_type} is: {total_sum}"
                else:
                    report = f"I am sorry but there is no data regarding {report_type} of {report_amount} products from {start_date} to {end_date}."

                print(f"Result of {report_type}:\n", result)
            elif report_amount == "One":
                params = (filter_value, category, start_date_param, end_date_param, report_type, product_id, step)
                result = DatabaseManager.call_stored_procedure(procedure_name="view_profit_report", params=params)

                if len(result) != 0:
                    report = (f"Here is the {report_type} of {report_amount.lower()} product, with id: {product_id}.\n"
                              f"From {start_date} to {end_date}:\n")

                    for row in result:
                        period_start = datetime.strptime(str(row['period_start']), "%Y-%m-%d")
                        period_end = datetime.strptime(str(row['period_end']), "%Y-%m-%d")
                        total = row['total']

                        if total is None:
                            total = 0

                        total_sum += total

                        report += f"{period_start} to {period_end}: {total}\n"

                    report += f"With total {report_type} is: {total_sum}"
                    print(f"Result of {report_type}:\n", result)
                else:
                    report = f"I am sorry but there is no data regarding {report_type} of product with id: {product_id}, from {start_date} to {end_date}"

        dispatcher.utter_message(text=report)
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

class ActionDeactivateLoop(Action):
    def name(self) -> Text:
        return "action_deactivate_loop"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        return []

class ActionInformRestart(Action):
    def name(self) -> Text:
        return "action_inform_restart"

    def run(
        self,
        dispatcher: "CollectingDispatcher",
        tracker: Tracker,
        domain: "DomainDict",
    ) -> List[Dict[Text, Any]]:

        text = "I have reset everything for you. What would you like me to do now ?"
        buttons = [
            {
                "title": "I want to see report of shopping trends",
                "payload": "shopping trends"
            },

            {
                "title": "I want to see revenue report",
                "payload": "revenue report"
            },

            {
                "title": "I want to see profits report",
                "payload": "profits report"
            }
        ]

        dispatcher.utter_message(text=text, buttons=buttons)
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