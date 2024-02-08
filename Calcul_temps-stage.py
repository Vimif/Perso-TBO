import requests
import csv

# Configuration initiale
GITLAB_TOKEN = 'your_gitlab_token'
GITLAB_PROJECT_ID = 'your_project_id'
GITLAB_API_URL = 'https://gitlab.com/api/v4'

# Fonction pour récupérer l'ID du dernier pipeline réussi
def fetch_last_successful_pipeline_id():

    """
    Récupère l'ID du dernier pipeline réussi.
    """

    url = f'{GITLAB_API_URL}/projects/{GITLAB_PROJECT_ID}/pipelines?status=success&ref=main'
    headers = {'PRIVATE-TOKEN': GITLAB_TOKEN}
    response = requests.get(url, headers=headers)
    pipelines = response.json()
    
    if not pipelines:
        print("Aucun pipeline réussi trouvé.")
        return None
    
    return pipelines[0]['id']

# Fonction pour récupérer les jobs d'un pipeline
def fetch_jobs_from_pipeline(pipeline_id):

    """
    Récupère tous les jobs pour un pipeline donné.
    """

    url = f'{GITLAB_API_URL}/projects/{GITLAB_PROJECT_ID}/pipelines/{pipeline_id}/jobs'
    headers = {'PRIVATE-TOKEN': GITLAB_TOKEN}
    response = requests.get(url, headers=headers)
    
    return response.json()

# Fonction pour traiter les jobs et calculer les durées
def process_jobs(jobs):

    """
    Traite les jobs, calcule le temps total par stage et la durée en minutes de chaque job.
    """

    stage_durations = {}
    for job in jobs:
        stage = job['stage']
        duration = job.get('duration', 0) or 0
        duration_minutes = duration / 60
        job['duration_minutes'] = duration_minutes
        
        stage_durations[stage] = stage_durations.get(stage, 0) + duration_minutes
    
    return jobs, stage_durations

# Fonction pour exporter les détails des jobs dans un fichier CSV
def export_jobs_to_csv(jobs, filename="jobs_details.csv"):

    """
    Exporte les détails des jobs dans un fichier CSV.
    """

    with open(filename, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['Stage', 'Job Name', 'Duration (min)'])
        
        for job in jobs:
            writer.writerow([job['stage'], job['name'], f"{job['duration_minutes']:.2f}"])

# Fonction pour exporter les durées par stage dans un fichier CSV
def export_stages_to_csv(stage_durations, filename="stages_summary.csv"):

    """
    Exporte le temps total par stage dans un fichier CSV.
    """

    with open(filename, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['Stage', 'Total Duration (min)'])
        
        for stage, duration in stage_durations.items():
            writer.writerow([stage, f"{duration:.2f}"])

# Fonction principale
def main():

    """
    Fonction principale pour orchestrer le script.
    """
    
    pipeline_id = fetch_last_successful_pipeline_id()
    if not pipeline_id:
        return
    
    jobs = fetch_jobs_from_pipeline(pipeline_id)
    jobs, stage_durations = process_jobs(jobs)
    
    export_jobs_to_csv(jobs)
    export_stages_to_csv(stage_durations)
    
    print("Les données ont été exportées avec succès.")

if __name__ == '__main__':
    main()