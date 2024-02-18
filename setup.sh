#!/bin/bash

# Function to check if a package is installed
package_installed() {
    dpkg -s "$1" &> /dev/null
}

if ! package_installed "npm"; then
    echo "Error: npm is not installed. Please install Node.js/npm before running this script."
    exit 1
fi

# Function to prompt user for input with a default value
prompt() {
    read -p "$1 [$2]: " input
    echo ${input:-$2}
}

mkdir backend

cd backend

# Initialize Node.js project
npm init -y

# Install necessary packages

npm install express cors 
npm install @supabase/supabase-js

# Add code to package.json

echo "{
  \"scripts\": {
    \"start\": \"node index.js\"
  }
}" > package.json

echo "package.json has been updated with start script."

# Create necessary folders

mkdir -p src/routes src/controllers

# Create necessary files

touch src/routes/index.js src/controllers/index.js index.js

# Add code to index.js

echo "const express = require('express');

const app = express();

app.use(express.json());

app.use(require('./routes'));

app.listen(3001, () => {
    console.log('Server is running on port 3001');
});" > index.js

# Add code to routes/index.js

echo "const express = require('express');

const router = express.Router();

router.get('/', (req, res) => {
    res.send('Hello, world!');
});

module.exports = router;" > src/routes/index.js

# Add code to controllers/index.js

echo "const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_API_KEY);

module.exports = {
    supabase
};" > src/controllers/index.js

# Prompt user for Supabase URL

supabase_url=$(prompt "Enter your Supabase URL" "your_supabase_url")

# Create .env file with Supabase URL placeholder

echo "SUPABASE_URL=${supabase_url}" > .env

echo "Backend setup completed. Your Supabase URL has been added to the .env file."

# Prompt user for Supabase API key
supabase_api_key=$(prompt "Enter your Supabase API key" "your_supabase_api_key")

# Append Supabase API key to .env file

echo "SUPABASE_API_KEY=${supabase_api_key}" >> .env

echo "Your Supabase API key has been added to the .env file."

cd ..

mkdir frontend

cd frontend

# Initialize React app

npx create-react-app .

# Create necessary folders

mkdir -p src/components src/pages

echo "Frontend setup completed. React app created with necessary folders."

# Add code to App.js

echo "import React, { useEffect, useState } from 'react';

function App() {
  const [message, setMessage] = useState('');

  useEffect(() => {
    fetch('http://localhost:3001')
      .then(res => res.text())
      .then(data => setMessage(data));
  }, []);

  return (
    <div>
      <h1>{message}</h1>
    </div>
  );
}

export default App;" > src/App.js

echo "App.js has been updated with code to fetch data from the backend."

# Add code to package.json

echo "{
  \"proxy\": \"http://localhost:3001\"
}" > package.json

echo "package.json has been updated with proxy setting to redirect API requests to the backend."

echo "Frontend setup completed. Your React app is ready to use."

