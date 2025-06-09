
def test_trend_follow_get_success(client,mocker):
    mock_response ={
        'stock_history' : [{'date':'2024-0101', 'Close': 100}],
        'stock_info' : {'lastCrossTrendFollow' : 1.0}
    }

    mock_service = mocker.patch(
        'api.quant.controller.controllers.QuantService'
    )

    mock_service.return_value.find_stock_by_id.return_value = mock_response

    response = client.get('api/v1/quants/trend-follow/us/aapl')
    assert response.status_code == 200
    assert response.json['stock_info']['lastCrossTrendFollow'] == 1.0