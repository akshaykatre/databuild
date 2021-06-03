import dash
import dash_table
import pandas as pd

df = pd.read_csv('test_data.csv', index_col=False)
df = df.fillna(0)

app = dash.Dash(__name__)

app.layout = dash_table.DataTable(
    id='table',
    columns=[{"name": i, "id": i} for i in df.columns],
    data=df.to_dict('records'),
    filter_action="native",
    sort_action="native",
    sort_mode="multi",
    page_size=25,
    style_data_conditional=[
        {
            'if':{
                'filter_query': '{Per_Missing_val} > 0.01',
            },
            'backgroundColor': '#FF4136',
            'color': 'white'         
        }
    ]
)
external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

if __name__ == '__main__':
    app.run_server(debug=True)

