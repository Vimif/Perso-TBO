### Calcul_temps-stage.py ###

import requests
import csv

# Configuration initiale
GITLAB_TOKEN = 'your_gitlab_token'
GITLAB_PROJECT_ID = 'your_project_id'
GITLAB_API_URL = 'https://gitlab.com/api/v4'

def fetch_last_successful_pipeline_id():
    pipelines_url = f'{GITLAB_API_URL}/projects/{GITLAB_PROJECT_ID}/pipelines?status=success&ref=main'
    headers = {'PRIVATE-TOKEN': GITLAB_TOKEN}
    response = requests.get(pipelines_url, headers=headers)
    pipelines = response.json()
    if pipelines:
        return pipelines[0]['id']
    return None

def fetch_jobs_from_pipeline(pipeline_id):
    jobs_url = f'{GITLAB_API_URL}/projects/{GITLAB_PROJECT_ID}/pipelines/{pipeline_id}/jobs'
    headers = {'PRIVATE-TOKEN': GITLAB_TOKEN}
    response = requests.get(jobs_url, headers=headers)
    return response.json()

def process_jobs(jobs):
    stage_durations = {}
    sorted_jobs = sorted(jobs, key=lambda x: (x['stage'], x['name']))
    
    for job in sorted_jobs:
        stage = job['stage']
        duration_seconds = job.get('duration', 0) or 0
        duration_minutes = duration_seconds / 60
        job['duration_minutes'] = duration_minutes
        
        if stage in stage_durations:
            stage_durations[stage] += duration_minutes
        else:
            stage_durations[stage] = duration_minutes

    return sorted_jobs, stage_durations

def export_jobs_to_csv(jobs, filename="jobs_details.csv"):
    with open(filename, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['Stage', 'Job Name', 'Duration (min)'])
        for job in jobs:
            writer.writerow([job['stage'], job['name'], f"{job['duration_minutes']:.2f}"])

def export_stages_to_csv(stage_durations, filename="stages_summary.csv"):
    with open(filename, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['Stage', 'Total Duration (min)'])
        for stage, duration in stage_durations.items():
            writer.writerow([stage, f"{duration:.2f}"])

def main():
    pipeline_id = fetch_last_successful_pipeline_id()
    if pipeline_id:
        jobs = fetch_jobs_from_pipeline(pipeline_id)
        sorted_jobs, stage_durations = process_jobs(jobs)
        export_jobs_to_csv(sorted_jobs)
        export_stages_to_csv(stage_durations)
        print("Les données ont été exportées avec succès.")
    else:
        print("Aucun pipeline réussi trouvé ou erreur lors de la récupération des données.")

if __name__ == '__main__':
    main()