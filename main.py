import os
import json
from flask import Flask, request, render_template
from web3 import Web3
from dotenv import load_dotenv
import os


load_dotenv()
eth_provider = os.getenv("ETH_PROVIDER")
private_key = os.getenv("PRIVATE_KEY")
print(eth_provider, private_key)

app = Flask(__name__, template_folder='templates', static_folder='static')


@app.route('/')
def index():
    return render_template('main.html', eth_bal=eth_bal)


# Loading ABI from file
with open(os.path.join(os.path.dirname(__file__), 'contracts', 'my_contract.abi')) as f:
    abi = json.load(f)


web3 = Web3(Web3.HTTPProvider(eth_provider))
account = web3.eth.account.privateKeyToAccount(private_key)
from_address = web3.toChecksumAddress(account.address)
contract_address = '0x3677Dd8370468f9Ef474877B51657E7D81f9123F'
eth_bal = web3.eth.getBalance(contract_address)
eth_bal = eth_bal / 1000000000000000000
eth_bal = round(eth_bal, 3)

# Creating contract instance using the ABI and contract address
contract = web3.eth.contract(address=contract_address, abi=abi)


@app.route('/faucet', methods=["POST"])
def faucet():
    if request.method == "POST":
        recipient_address = request.form.get('recipient_address')
        try:
            recipient_address = web3.toChecksumAddress(recipient_address)

            # Prepare function call data
            function_name = 'requestTokens'
            function_args = [recipient_address]

            # Encode the function call data using the ABI
            function = contract.functions[function_name](*function_args)

            # Getting current network status
            nonce = web3.eth.getTransactionCount(from_address)
            gasprice = web3.eth.gasPrice
            gasprice = gasprice / 1000000000
            gasprice = gasprice * 1.2

            # Getting function call data
            function_data = function.buildTransaction({
                'gas': 100000,
                'gasPrice': web3.toWei(100000000, 'wei'),
                'from': from_address,
                'nonce': nonce
            })['data']

            # Send the transaction to the network
            tx_params = {
                'to': contract_address,
                'data': function_data,
                'gas': 100000,
                'gasPrice': web3.toWei(gasprice, 'gwei'),
                'nonce': nonce
            }

            # sign the transaction with your private key
            signed_tx = account.signTransaction(tx_params)

            # send the transaction to the network
            tx_hash = web3.eth.sendRawTransaction(signed_tx.rawTransaction)

            explorer_link = f"https://explorer.goerli.zkevm.consensys.net/tx/{tx_hash.hex()}"

            return render_template('success.html', success=True, eth_bal=eth_bal, explorer_link=explorer_link,
                                   tx_hash=tx_hash.hex())

        except Exception as e:
            error_message = "Invalid Address."
            return render_template('error.html', error_message=error_message, eth_bal=eth_bal)


if __name__ == '__main__':
    app.run(debug=False)
